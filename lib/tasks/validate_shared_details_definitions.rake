require 'json'

def uses_definition?(property_value)
  property_value["$ref"] && property_value["$ref"].include?('definitions')
end

# A single use without definition is ok
def multiple_schemas_without_definition?(schemas)
  schemas.length > 1 && !schemas.all? { |f| f[:uses_definition] == true }
end

def schemas_without_definition(schemas)
  schemas.reject { |f| f[:uses_definition] == true }
end

task :validate_shared_details_definitions do
  shared_properties = {}
  definition_errors = []

  Dir.glob("formats/*/publisher/details.json").each do |filename|
    data = JSON.parse(File.read(filename))
    data["properties"].each do |property, value|
      shared_properties[property] = [] unless shared_properties[property]
      shared_properties[property] << { filename: filename, uses_definition: uses_definition?(value) }
    end
  end

  shared_properties.each do |property, schemas|
    if multiple_schemas_without_definition?(schemas)
      definition_errors << "'#{property}'\n#{schemas_without_definition(schemas).map {|f| "  - #{f[:filename]}\n" }.join}"
    end
  end

  abort "\nThe following properties are used in multiple schemas without a definition:\n\n" + definition_errors.join("\n") if definition_errors.any?
end
