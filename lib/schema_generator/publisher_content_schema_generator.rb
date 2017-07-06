module SchemaGenerator
  class PublisherContentSchemaGenerator
    def initialize(format)
      @format = format
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

    attr_reader :format

    def required
      fields = %w(
        document_type
        publishing_app
        schema_name
      ) + format.publisher_required
      fields.sort
    end

    def properties
      all_properties = default_properties.merge(derived_properties)
      Hash[ all_properties.sort_by { |k, _| k } ]
    end

    def default_properties
      Jsonnet.load("jsonnet_formats/shared/default_properties/publisher.jsonnet")
    end

    def derived_properties
      {
        "base_path" => format.base_path.definition,
        "document_type" => format.document_type.definition,
        "description" => format.description.definition,
        "details" => format.details.definition,
        "links" => format.edition_links.guid_definition,
        "redirects" => format.redirects.definition,
        "rendering_app" => format.rendering_app.definition,
        "routes" => format.routes.definition,
        "schema_name" => format.schema_name_definition,
        "title" => format.title.definition,
      }
    end

    def definitions
      all_definitions = Jsonnet
        .load("jsonnet_formats/shared/definitions/all.jsonnet")
        .merge(format.definitions)
      DefinitionsResolver.new(properties, all_definitions).call
    end
  #   def initialize(schema_name)
  #     @schema_name = schema_name
  #   end
  #
  #   def generate
  #     {
  #       "$schema" => "http://json-schema.org/draft-04/schema#",
  #       "type" => "object",
  #       "additionalProperties" => false,
  #       "required" => required,
  #       "properties" => properties,
  #       "definitions" => definitions,
  #     }
  #   end
  #
  # private
  #
  #   attr_reader :schema_name
  #
  #   def required
  #     required_properties = base_content_item["required"] + %w[document_type schema_name]
  #
  #     # TODO: `contact` and `world_location` are schema types that can be base path less.
  #     base_path_less_schemas = %w(contact world_location)
  #     if base_path_less_schemas.include?(schema_name)
  #       required_properties = required_properties - %w[rendering_app routes base_path]
  #     end
  #
  #     required_properties
  #   end
  #
  #   def properties
  #     base_content_item["properties"]
  #       .merge("links" => { "$ref" => "#/definitions/links" })
  #       .merge("document_type" => document_type_definition)
  #       .merge("schema_name" => schema_name_definition)
  #   end
  #
  #   def definitions
  #     details = Schema.read("formats/#{schema_name}/publisher/details.json")
  #
  #     base = {
  #       "details" => details.slice("type", "additionalProperties", "required", "properties")
  #     }
  #
  #     base
  #       .merge(base_content_item["definitions"])
  #       .merge(links_schema)
  #       .merge(definitions_schema)
  #       .merge(details["definitions"].to_h)
  #   end
  #
  #   def document_type_definition
  #     {
  #       "type" => "string",
  #       "enum" => YAML.load_file("lib/govuk_content_schemas/allowed_document_types.yml"),
  #     }
  #   end
  #
  #   def schema_name_definition
  #     if schema_name == "placeholder"
  #       {
  #         "type": "string",
  #         "pattern": "^(placeholder|placeholder_.+)$",
  #         "description": "Should be of the form 'placeholder_my_format_name'. 'placeholder' is allowed for backwards compatibility.",
  #       }
  #     else
  #       {
  #         "type" => "string",
  #         "enum" => [schema_name]
  #       }
  #     end
  #   end
  #
  #   def base_content_item
  #     Schema.read("formats/metadata.json")
  #   end
  #
  #   def base_edition_links
  #     Schema.read("formats/base_edition_links.json")
  #   end
  #
  #   def edition_links
  #     path  = "formats/#{schema_name}/publisher/edition_links.json"
  #     File.exists?(path) ? Schema.read(path) : {}
  #   end
  #
  #   def definitions_schema
  #     Schema.read("formats/definitions.json").dig("definitions")
  #   end
  #
  #   def links_schema
  #     fields = %w[additionalProperties required properties]
  #     edition_fields = edition_links.slice(*fields)
  #     base_fields = base_edition_links.slice(*fields)
  #
  #     additional_properties = edition_fields.fetch("additionalProperties", false) ||
  #       base_fields.fetch("additionalProperties", false)
  #     required = edition_fields.fetch("required", []) + base_fields.fetch("required", [])
  #     # TODO swap this so edition links prioritise base ones, it's the wrong way to avoid rewriting diffs
  #     # properties = base_fields.fetch("properties", {}).merge(edition_fields.fetch("properties", {}))
  #     properties = edition_fields.fetch("properties", {}).merge(base_fields.fetch("properties", {}))
  #
  #     links = {
  #       "links" => {
  #         "type" => "object",
  #         "additionalProperties" => additional_properties,
  #         "properties" => properties,
  #       }
  #     }
  #
  #     # TODO: this can be moved into above hash, not currently to avoid a diff in rewriting
  #     links["links"]["required"] = required unless required.empty?
  #     links
  #   end
  end
end
