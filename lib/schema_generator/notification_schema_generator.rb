module SchemaGenerator
  class NotificationSchemaGenerator
    def initialize(downstream_schema)
      @downstream_schema = downstream_schema
    end

    def generate
      Schema.generate(
        required: required,
        properties: properties,
        definitions: definitions,
      )
    end

  private

    attr_reader :downstream_schema

    def required
      downstream_schema.required + n
    end

    def properties
      frontend_schema["properties"].merge(notification_base["properties"])
    end

    def definitions
      downstream_schema.definitions
    end

    def notification_base
      Schema.read("formats/notification_base.json")
    end
  end
end
