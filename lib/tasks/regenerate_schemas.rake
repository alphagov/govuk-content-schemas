require "schema_generator/generator"
require "jsonnet"

task :regenerate_schemas do
  print "Generating schemas: "
  FileUtils.rm_rf("dist/formats")

  # Ignore files prefixed with an underscore
  Dir.glob("formats/{[!_]*}.jsonnet").each do |schema_filename|
    schema_name = File.basename(schema_filename, ".*")
    SchemaGenerator::Generator.generate(schema_name, Jsonnet.load(schema_filename))
    print "."
  end

  puts "✔︎"
end

# Pull in activesupport's slice. If we need more activesupport we should include the gem.
class Hash
  def slice(*keys)
    keys.map! { |key| convert_key(key) } if respond_to?(:convert_key, true)
    keys.each_with_object(self.class.new) { |k, hash| hash[k] = self[k] if has_key?(k) }
  end
end
