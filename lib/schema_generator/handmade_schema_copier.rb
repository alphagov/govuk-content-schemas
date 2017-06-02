module SchemaGenerator
  class HandmadeSchemaCopier
    def copy_schema(schema_name)
      FileUtils.mkdir_p("dist/formats/#{schema_name}/publisher_v2")
      FileUtils.cp("formats/#{schema_name}/publisher_v2/schema.json", "dist/formats/#{schema_name}/publisher_v2/schema.json")

      %w(frontend notification).each do |schema_type|
        if File.exist?("formats/#{schema_name}/#{schema_type}/schema.json")
          FileUtils.mkdir_p("dist/formats/#{schema_name}/#{schema_type}")
          FileUtils.cp("formats/#{schema_name}/#{schema_type}/schema.json", "dist/formats/#{schema_name}/#{schema_type}/schema.json")
        end
      end
    end
  end
end
