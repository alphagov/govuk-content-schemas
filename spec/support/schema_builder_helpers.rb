require 'json-schema'

module SchemaBuilderHelpers
  def build_schema(name, properties, definitions = nil)
    schema = {
      "$schema" => "http://json-schema.org/draft-04/schema#",
      "type" => "object",
      "properties" => properties
    }
    schema['definitions'] = definitions if definitions
    JSON::Schema.new(schema, URI.parse(name))
  end

  def build_string_properties(*properties)
    properties.inject({}) do |memo, property_name|
      memo.merge(property_name => {"type" => "string"})
    end
  end
end
