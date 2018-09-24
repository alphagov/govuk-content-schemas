module SchemaGenerator
  class PublisherContentSchemaGenerator
    def initialize(format, global_definitions)
      @format = format
      @global_definitions = global_definitions
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

    attr_reader :format, :global_definitions

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
    end

    def default_properties
      Jsonnet.load("formats/shared/default_properties/publisher.jsonnet")
    end

    def derived_properties
      {
        "base_path" => format.base_path.schema,
        "document_type" => format.document_type.schema,
        "description" => format.description.schema,
        "details" => format.details.schema,
        "links" => links,
        "redirects" => format.redirects.schema,
        "rendering_app" => format.rendering_app.schema,
        "routes" => format.routes.schema,
        "schema_name" => format.schema_name_schema,
        "title" => format.title.schema,
      }
    end

    def definitions
      all_definitions = global_definitions.merge(format.definitions)
      DefinitionsResolver.new(properties, all_definitions).call
    end

    def links
      links = {
        "type" => "object",
        "additionalProperties" => false,
        "properties" => format.edition_links.guid_properties,
      }
      required_links = format.edition_links.required_links
      links["required"] = required_links if required_links.any?
      links
    end
  end
end
