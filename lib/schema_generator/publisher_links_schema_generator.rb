module SchemaGenerator
  class PublisherLinksSchemaGenerator
    def initialize(format)
      @format = format
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

    attr_reader :format

    def properties
      {
        "links" => links,
        "previous_version" => { "type" => "string" }
      }
    end

    def definitions
      all_definitions = Jsonnet
        .load("formats/shared/definitions/all.jsonnet")
        .merge(format.definitions)
      DefinitionsResolver.new(properties, all_definitions).call
    end

    def links
      {
        "type" => "object",
        "additionalProperties" => false,
        "properties" => format.content_links.guid_properties,
      }
    end
  end
end
