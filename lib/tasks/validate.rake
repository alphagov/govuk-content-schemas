def schema_path_for(example)
  schema_filename = example.end_with?("_links.json") ? "links.json" : "schema.json"
  (File.dirname(File.dirname(example)) + "/" + schema_filename).gsub(%r[formats/], "dist/formats/")
end

def valid?(example)
  errors = JSON::Validator.fully_validate(schema_path_for(example), example, validate_schema: true)
  if errors.any?
    $stderr.puts "#{example}: had #{errors.count} error(s):"
    errors.each { |error| $stderr.puts "  #{error}" }
  end
  errors.none?
end

def base_path(example_file)
  JSON.parse(File.read(example_file))["base_path"]
end

def validate_schemas(schema_file_list)
  validation_errors = []
  schema_file_list.each do |schema|
    begin
      JSON::Validator.fully_validate(schema, {}, validate_schema: true)
    rescue JSON::Schema::ValidationError => e
      validation_errors << "Schema: #{schema}: #{e.message}"
    end
  end
  abort "The following schemas aren't valid:\n" + validation_errors.join("\n") if validation_errors.any?
end

task :validate_source_schemas do
  schemas = Rake::FileList.new("formats/**/*.json")
  validate_schemas(schemas)
end

task :validate_dist_schemas do
  validate_schemas(Rake::FileList.new("dist/formats/**/*.json"))
end

task :validate_examples do
  examples = Rake::FileList.new("formats/**/examples/*.json")
  failed_examples = examples.reject { |example| valid?(example) }
  abort "The following examples don't validate against their schemas:\n" + failed_examples.join("\n") if failed_examples.any?
end

task :validate_uniqueness_of_frontend_example_base_paths, :files do |_, args|
  frontend_examples = args[:files] || Rake::FileList.new("formats/*/frontend/examples/*.json")
  grouped = frontend_examples.group_by { |file| base_path(file) }
  duplicates = grouped.select { |_, group| group.count > 1 }

  if duplicates.any?
    $stderr.puts "#{duplicates.count} duplicate(s) found:"

    duplicates.each do |_, group|
      group.each { |filename| $stderr.puts "  #{filename}" }
    end
    abort
  end
end
