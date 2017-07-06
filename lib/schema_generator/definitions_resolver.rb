module SchemaGenerator
  class DefinitionsResolver
    def initialize(properties, all_definitions)
      @properties = properties
      @all_definitions = all_definitions
    end

    def call
      definitions_from_properties = extract_definitions(properties)
      definitions_with_dependencies = resolve_depenencies(
        definitions_from_properties, definitions_from_properties
      )

      definitions = all_definitions.clone.delete_if do |k, _|
        !definitions_with_dependencies.include?(k)
      end

      Hash[ definitions.sort_by { |k, _| k } ]
    end

  private

    attr_reader :properties, :all_definitions

    def definition_dependencies
      @definition_dependencies ||= calculate_definition_dependencies
    end

    def calculate_definition_dependencies
      all_definitions.each_with_object({}) do |(k, v), memo|
        memo[k] = extract_definitions(v)
      end
    end

    def extract_definitions(properties)
      definitions = properties.inject([]) do |memo, (key, value)|
        if value.is_a?(Hash)
          memo + extract_definitions(value)
        elsif value.respond_to?(:map)
          memo + value.flat_map { |item| item.is_a?(Hash) ? extract_definitions(item) : nil }
        else
          key.to_s == "$ref" ? memo << value.sub("#/definitions/", "") : memo
        end
      end
      definitions.compact.uniq
    end

    def resolve_depenencies(definition_names, dependencies_found = [])
      names = definition_names.flat_map do |name|
        dependencies = definition_dependencies[name]
        raise "Undefined definition: #{name}" unless dependencies
        new_dependencies = dependencies - dependencies_found
        current_dependencies = dependencies_found + new_dependencies
        current_dependencies + resolve_depenencies(new_dependencies, current_dependencies)
      end
      names.uniq
    end
  end
end
