require "jsonnet"
require "schema_generator/schema"
require "schema_generator/publisher_content_schema_generator"
require "schema_generator/publisher_links_schema_generator"
require "schema_generator/frontend_schema_generator"
require "schema_generator/notification_schema_generator"
require "schema_generator/format"
require "schema_generator/definitions_resolver"
require "schema_generator/expanded_links"
require "schema_generator/apply_change_history"

module SchemaGenerator
  module Generator
    # @param schema_name [String] like `generic` or `specialist_document`
    # @param data [Hash] the data from the format definition
    def self.generate(schema_name, data)
      format = Format.new(schema_name, data)

      publisher_content_schema = PublisherContentSchemaGenerator.new(format).generate
      Schema.write("dist/formats/#{schema_name}/publisher_v2/schema.json", publisher_content_schema)

      publisher_links_schema = PublisherLinksSchemaGenerator.new(format).generate
      Schema.write("dist/formats/#{schema_name}/publisher_v2/links.json", publisher_links_schema)

      notification_schema = NotificationSchemaGenerator.new(format).generate
      Schema.write("dist/formats/#{schema_name}/notification/schema.json", notification_schema)

      if format.frontend?
        frontend_schema = FrontendSchemaGenerator.new(format).generate
        Schema.write("dist/formats/#{schema_name}/frontend/schema.json", frontend_schema)
      end
    end
  end
end
