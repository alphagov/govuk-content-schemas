module SchemaGenerator
  class PublisherLinksSchemaGenerator
    def initialize(schema_name)
      @schema_name = schema_name
    end

    def generate
      {
        "$schema" => "http://json-schema.org/draft-04/schema#",
        "type" => "object",
        "additionalProperties" => false,
        # Note that we don't allow `required` links because this would prevent
        # publishing-api to validate partial payload for PATCH requests.
        "properties" => properties,
        "definitions" => definitions,
      }
    end

  private

    attr_reader :schema_name

    def properties
      links = Schema.read("formats/base_links.json").slice("type", "additionalProperties", "properties")

      custom_links_filename = "formats/#{schema_name}/publisher/links.json"
      if File.exist?(custom_links_filename)
        custom_links_schema = Schema.read(custom_links_filename)

        links["properties"] = custom_links_schema["properties"].merge(
          links["properties"]
        )
      end

      props = Schema.read("formats/links_metadata.json")["properties"]
      props["links"] = links
      props
    end

    def definitions
      Schema.read("formats/definitions.json")["definitions"]
    end

    def links_metadata
      Schema.read("formats/links_metadata.json")
    end
  end
end
