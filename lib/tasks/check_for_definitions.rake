require 'json'

task :check_for_definitions do
  usage = {}
  definition_errors = []

  Dir.glob("formats/*/publisher/details.json").each do |filename|
    data = JSON.parse(File.read(filename))
    data["properties"].each do |feature, value|
      if usage[feature]
        usage[feature][:files] << filename

        if usage[feature][:uses_definition]
          usage[feature][:uses_definition] = value["$ref"] && value["$ref"].include?('definitions')
        end
      else
        usage[feature] = {
          uses_definition: value["$ref"] && value["$ref"].include?('definitions'),
          files: [filename]
        }
      end
    end
  end

  usage.each do |feature_name, feature|
    if feature[:files].length > 1 && !feature[:uses_definition]
      definition_errors << "'#{feature_name}'\n#{feature[:files].map {|f| "  - #{f}\n" }.join}"
    end
  end

  abort "\nThe following features are used in multiple schemas without definitions:\n\n" + definition_errors.join("\n") if definition_errors.any?
end
