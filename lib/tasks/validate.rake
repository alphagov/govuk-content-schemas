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

task :validate_examples do
  examples = Rake::FileList.new("formats/**/examples/*.json")
  failed_examples = examples.reject { |example| valid?(example) }
  abort "The following examples don't validate against their schemas:\n" + failed_examples.join("\n") if failed_examples.any?
end
