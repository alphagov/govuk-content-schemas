module SchemaGenerator
  class PublisherContentSchemaGenerator
    def initialize(schema_name)
      @schema_name = schema_name
    end

    def generate
      {
        "$schema" => "http://json-schema.org/draft-04/schema#",
        "type" => "object",
        "additionalProperties" => false,
        "required" => required,
        "properties" => properties,
        "definitions" => definitions,
      }
    end

  private

    attr_reader :schema_name

    def required
      required_properties = base_content_item["required"] + other_base_content_item["required"] + %w[document_type schema_name]

      # TODO: `contact` is a content item that is can be base path less.
      if schema_name == "contact"
        required_properties = required_properties - %w[rendering_app routes base_path]
      end

      required_properties
    end

    def properties
      base_content_item["properties"]
        .merge(other_base_content_item["properties"])
        .merge("links" => { "$ref" => "#/definitions/links" })
        .merge("document_type" => document_type_definition)
        .merge("schema_name" => schema_name_definition)
    end

    def definitions
      details = Schema.read("formats/#{schema_name}/publisher/details.json")

      base = {
        "details" => details.slice("type", "additionalProperties", "required", "properties")
      }

      base
        .merge(base_content_item["definitions"])
        .merge("links" => base_edition_links.slice("type", "additionalProperties", "required", "properties"))
        .merge(definitions_schema)
        .merge(details["definitions"].to_h)
    end

    def document_type_definition
      if schema_name == "specialist_document"
        Schema.read("formats/specialist_document/publisher/document_types.json").dig("properties", "document_type")
      else
        {
          "type" => "string",
          "enum" => YAML.load_file("lib/govuk_content_schemas/allowed_document_types.yml"),
        }
      end
    end

    def schema_name_definition
      if schema_name == "placeholder"
        {
          "type": "string",
          "pattern": "^(placeholder|placeholder_.+)$",
          "description": "Should be of the form 'placeholder_my_format_name'. 'placeholder' is allowed for backwards compatibility.",
        }
      else
        {
          "type" => "string",
          "enum" => [schema_name]
        }
      end
    end

    def base_content_item
      Schema.read("formats/metadata.json")
    end

    def base_edition_links
      Schema.read("formats/base_edition_links.json")
    end

    def other_base_content_item
      # TODO: once the v1 schemas are gone, we can merge this with `metadata.json`
      Schema.read("formats/v2_metadata.json")
    end

    def definitions_schema
      Schema.read("formats/definitions.json").dig("definitions")
    end
  end
end
