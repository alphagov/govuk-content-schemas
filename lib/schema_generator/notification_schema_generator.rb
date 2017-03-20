module SchemaGenerator
  class NotificationSchemaGenerator
    def initialize(frontend_schema)
      @frontend_schema = frontend_schema
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

    attr_reader :frontend_schema

    def required
      (frontend_schema["required"] + notification_base["required"]).uniq.sort
    end

    def properties
      frontend_schema["properties"].merge(notification_base["properties"])
    end

    def definitions
      frontend_schema["definitions"]
    end

    def notification_base
      Schema.read("formats/notification_base.json")
    end
  end
end
