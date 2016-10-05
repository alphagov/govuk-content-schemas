require "govuk_content_schemas"

class GovukContentSchemas::FinderSchemaConverter
  attr_reader :document_type_mapper, :select_field_multiplicity_identifier

  def initialize(document_type_mapper: default_document_type_mapper, select_field_multiplicity_identifier: default_select_field_multiplicity_identifier)
    @document_type_mapper = document_type_mapper
    @select_field_multiplicity_identifier = select_field_multiplicity_identifier
  end

  def default_document_type_mapper
    ->(filename) { File.basename(filename, ".json") }
  end

  def default_select_field_multiplicity_identifier
    ->(_, _) { false }
  end

  def call(*files)
    definitions = files.map do |file|
      FinderSchema.new(file,
        document_type_mapper: document_type_mapper,
        select_field_multiplicity_identifier: select_field_multiplicity_identifier
      )
    end
    {
      "definitions" => definitions.map(&:definition).inject(&:merge)
    }
  end

  class FinderSchema
    attr_reader :file, :document_type_mapper, :select_field_multiplicity_identifier

    def initialize(file, document_type_mapper:, select_field_multiplicity_identifier:)
      @file = file
      @document_type_mapper = document_type_mapper
      @select_field_multiplicity_identifier = ->(facet_name) { select_field_multiplicity_identifier.call(document_type, facet_name) }
    end

    def definition
      {
        definition_name => {
          "type" => "object",
          "additionalProperties" => false,
          "properties" => properties
        }
      }
    end

    def definition_name
      "#{document_type}_metadata"
    end

    def document_type
      document_type_mapper.call(file)
    end

    def properties
      ([document_type_definition] + facets.map(&:as_json_schema)).inject(&:merge)
    end

    def facets
      data["facets"].map { |facet_json| FinderFacet.type_of(select_field_multiplicity_identifier, facet_json).new(facet_json) }
    end

    def document_type_definition
      {
        "document_type" => {
          "type" => "string",
          "enum" => [document_type]
        }
      }
    end

    def data
      @data ||= JSON.parse(File.read(file))
    end
  end

  class FinderFacet
    attr_reader :json

    def self.type_of(select_field_multiplicity_identifier, json)
      if json["type"] == "text" && json.has_key?("allowed_values")
        if select_field_multiplicity_identifier.call(json["key"])
          FinderArrayFacet
        else
          FinderSingleSelectFacet
        end
      elsif json["type"] == "text"
        FinderStringFacet
      elsif json["type"] == "date"
        FinderDateFacet
      else
        raise "Unknown finder facet type #{json['type']}"
      end
    end

    def initialize(json)
      @json = json
    end

    def facet_name
      json["key"]
    end
  end

  class FinderArrayFacet < FinderFacet
    def as_json_schema
      {
        facet_name => {
          "type" => "array",
          "items" => {
            "type" => "string",
            "enum" => allowed_values
          }
        }
      }
    end

    def allowed_values
      json["allowed_values"].map { |record| record["value"] }
    end
  end

  class FinderSingleSelectFacet < FinderFacet
    def as_json_schema
      {
        facet_name => {
          "type" => "string",
          "enum" => allowed_values
        }
      }
    end

    def allowed_values
      json["allowed_values"].map { |record| record["value"] }
    end
  end

  class FinderDateFacet < FinderFacet
    def as_json_schema
      {
        facet_name => {
          "type" => "string",
          "pattern" => "^[1-9][0-9]{3}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[0-1])$"
        }
      }
    end
  end

  class FinderStringFacet < FinderFacet
    def as_json_schema
      {
        facet_name => {
          "type" => "string"
        }
      }
    end
  end
end
