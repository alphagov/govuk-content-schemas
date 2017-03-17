require "byebug"

module SchemaGenerator
  class FrontendSchemaGenerator
    def initialize(downstream_schema)
      @downstream_schema = downstream_schema
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

    attr_reader :downstream_schema

    def required
      downstream_schema.required + %w(updated_at)
    end

    def properties
      to_remove = %w(access_limited redirects routes previous_version update_type)
      properties = downstream_schema.properties
      properties.slice(*(properties.keys - to_remove))
        .merge(
          "links" => downstream_schema.expanded_links_properties,
          "updated_at" => {
            "type" => "string",
            "format" => "date-time"
          }
        )
    end

    def definitions
      downstream_schema.definitions.merge(
        "expanded_links" => expanded_links_definition
      )
    end

    def expanded_links_definition
      downstream_schema.expanded_links_definition.tap do |definition|
        definition["items"]["properties"] = definition["items"]["properties"].merge(
          "api_url" => {
            "description" => "DEPRECATED: api_path should be used instead of api_url. This is due to values of api_url being tied to an environment which can cause problems when data is synced between environments. In time this field will be removed by the Publishing Platform team.",
            "type" => "string",
            "format" => "uri",
          },
          "web_url" => {
            "description" => "DEPRECATED: base_path should be used instead of web_url. This is due to values of web_url being tied to an environment which can cause problems when data is synced between environments. In time this field will be removed by the Publishing Platform team.",
            "type" => "string",
            "format" => "uri"
          },
        ).sort.to_h
      end
    end
  end
end
