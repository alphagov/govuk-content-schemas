require "json-schema"

def schema_path_for(example)
  schema_filename = example.end_with?("_links.json") ? "links.json" : "schema.json"
  dirname = File.dirname(example).gsub("publisher/", "publisher_v2/")
  (File.dirname(dirname) + "/" + schema_filename).gsub(%r[formats/], "dist/formats/")
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
      validation_errors << "#{schema}: #{e.message}"
    end
  end
  abort "\nThe following schemas aren't valid:\n" + validation_errors.join("\n") if validation_errors.any?
end

desc 'Validate that generated schemas are valid schemas'
task :validate_dist_schemas do
  print "Validating generated schemas... "
  validate_schemas(Rake::FileList.new("dist/formats/**/*.json"))
  puts "✔︎"
end

desc 'Validate examples against generated schemas'
task :validate_examples do
  print "Validating examples... "
  examples = Rake::FileList.new("formats/**/examples/*.json")
  failed_examples = examples.reject { |example| valid?(example) }
  abort "\nThe following examples don't validate against their schemas:\n" + failed_examples.join("\n") if failed_examples.any?
  puts "✔︎"
end

desc 'Validate uniqueness of frontend example base paths'
task :validate_uniqueness_of_frontend_example_base_paths, :files do |_, args|
  print "Checking that all frontend examples have unique base paths... "
  frontend_examples = args[:files] || Rake::FileList.new("formats/*/frontend/examples/*.json")
  grouped = frontend_examples.group_by { |file| base_path(file) }
  duplicates = grouped.select { |_, group| group.count > 1 }

  if duplicates.any?
    $stderr.puts "\n#{duplicates.count} duplicate(s) found:"

    duplicates.each do |_, group|
      group.each { |filename| $stderr.puts "  #{filename}" }
    end
    abort
  end
  puts "✔︎"
end

desc 'Validate links'
task :validate_links, :files do |_, args|
  print "Validating links... "
  link_schemas = args[:files] || Rake::FileList.new("formats/*/*/links.json")
  link_schemas.each do |filename|
    schema = JSON.parse(File.read(filename))
    if schema["required"]
      $stderr.puts "\nERROR: #{filename} has required links (#{schema["required"].inspect})"
      $stderr.puts "This is disallowed because the publishing-api wouldn't be able to validate partial payloads when sending a PATCH links request."
      abort
    end
  end
  puts "✔︎"
end
