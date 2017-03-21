module SchemaGenerator
  class HandmadeSchemaCopier
    def copy_schema(schema_name)
      FileUtils.mkdir_p("dist/formats/#{schema_name}/publisher_v2")
      FileUtils.cp("formats/#{schema_name}/publisher_v2/schema.json", "dist/formats/#{schema_name}/publisher_v2/schema.json")

      if File.exist?("formats/#{schema_name}/frontend/schema.json")
        FileUtils.mkdir_p("dist/formats/#{schema_name}/frontend")
        FileUtils.cp("formats/#{schema_name}/frontend/schema.json", "dist/formats/#{schema_name}/frontend/schema.json")
      end
    end
  end
end
