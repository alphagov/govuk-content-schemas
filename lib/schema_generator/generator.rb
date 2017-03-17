require "schema_generator/schema"
require "schema_generator/handmade_schema_copier"
require "schema_generator/publisher_content_schema_generator"
require "schema_generator/publisher_links_schema_generator"
require "schema_generator/publisher_downstream_schema_generator"
require "schema_generator/notification_schema_generator"

module SchemaGenerator
  module Generator
    # @param schema_name [String] like `generic` or `specialist_document`
    def self.generate(schema_name)
      # TODO: Stop using hand-made schemas, they make things confusing.
      if File.exist?("formats/#{schema_name}/publisher_v2/schema.json")
        HandmadeSchemaCopier.new.copy_schema(schema_name)
        return
      end

      publisher_content_schema = PublisherContentSchemaGenerator.new(schema_name).generate
      Schema.write("dist/formats/#{schema_name}/publisher_v2/schema.json", publisher_content_schema)

      publisher_links_schema = PublisherLinksSchemaGenerator.new(schema_name).generate
      Schema.write("dist/formats/#{schema_name}/publisher_v2/links.json", publisher_links_schema)

      frontend_schema = DownstreamSchemaGenerator.new(schema_name, publisher_content_schema, publisher_links_schema).generate
      Schema.write("dist/formats/#{schema_name}/frontend/schema.json", frontend_schema)

      notification_schema = NotificationSchemaGenerator.new(frontend_schema).generate
      Schema.write("dist/formats/#{schema_name}/notification/schema.json", notification_schema)
    end
  end
end
