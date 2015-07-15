require 'govuk_content_schemas'

class GovukContentSchemas::FinderSchemaConverter
  attr_reader :document_type_mapper

  def initialize(document_type_mapper: default_document_type_mapper)
    @document_type_mapper = document_type_mapper
  end

  def default_document_type_mapper
    ->(filename) { File.basename(filename, '.json') }
  end

  def call(*files)
    definitions = files.map { |file| FinderSchema.new(file, document_type_mapper: document_type_mapper) }.map(&:definition)
    {
      "definitions" => definitions.inject(&:merge)
    }
  end

  class FinderSchema
    attr_reader :file, :document_type_mapper

    def initialize(file, document_type_mapper: )
      @file = file
      @document_type_mapper = document_type_mapper
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
      data['facets'].map { |facet_json| FinderFacet.facet_for(facet_json) }
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

    def self.facet_for(json)
      type_of(json).new(json)
    end

    def self.type_of(json)
      facet_classes.find { |klass| klass.of_type?(json) }
    end

    def self.facet_classes
      ObjectSpace.each_object(::Class).select {|klass| klass < self }
    end

    def initialize(json)
      @json = json
    end

    def facet_name
      json['key']
    end

  end

  class FinderArrayFacet < FinderFacet
    def self.of_type?(json)
      json['type'] == 'text' && json.has_key?('allowed_values')
    end

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
      json['allowed_values'].map { |record| record['value'] }
    end
  end

  class FinderDateFacet < FinderFacet
    def self.of_type?(json)
      json['type'] == 'date'
    end

    def as_json_schema
      {
        facet_name => {
          "type" => "string",
          "pattern" => "^[1-9][0-9]{3}-(0[1-9]|1[0-2])-([012][0-9]|3[0-1])$"
        }
      }
    end
  end

  class FinderStringFacet < FinderFacet
    def self.of_type?(json)
      json['type'] == 'text' && !json.has_key?('allowed_values')
    end

    def as_json_schema
      {
        facet_name => {
          "type" => "string"
        }
      }
    end
  end
end
