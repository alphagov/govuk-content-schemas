def schema_path_for(example)
  schema_filename = example.end_with?("_links.json") ? "links.json" : "schema.json"
  candidates = []
  candidates << (File.dirname(File.dirname(example)) + "/" + schema_filename).gsub(%r{formats/}, "dist/formats/")
  candidates << (File.dirname(File.dirname(example)) + "/" + schema_filename).gsub(%r{formats/}, "formats/")
  candidates.find { |path| File.exist?(path) }
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
  JSON.parse(File.read(example_file))['base_path']
end

task :validate_examples do
  examples = Rake::FileList.new("formats/**/examples/*.json")
  failed_examples = examples.reject { |example| valid?(example) }
  abort "The following examples don't validate against their schemas:\n" + failed_examples.join("\n") if failed_examples.any?
end

task :validate_uniqueness_of_frontend_example_base_paths, :files do |t, args|
  frontend_examples = args[:files] || Rake::FileList.new("formats/*/frontend/examples/*.json")
  grouped = frontend_examples.group_by {|file| base_path(file) }
  duplicates = grouped.select {|base_path, group| group.count > 1 }

  if duplicates.any?
    $stderr.puts "#{duplicates.count} duplicate(s) found:"

    duplicates.each do |base_path, group|
      group.each do |filename|
        $stderr.puts "  #{filename}"
      end
    end
    abort
  end
end
