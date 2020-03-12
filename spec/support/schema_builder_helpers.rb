require "pathname"
require "json-schema"

module SchemaBuilderHelpers
  def project_root
    Pathname.new(File.expand_path("../../", __dir__))
  end

  def build_schema(name, properties: nil, definitions: nil, required: nil)
    schema = {
      "$schema" => "http://json-schema.org/draft-04/schema#",
      "type" => "object",
    }
    schema["properties"] = properties if properties
    schema["definitions"] = definitions if definitions
    schema["required"] = required if required
    JSON::Schema.new(schema, URI.parse(name))
  end

  def build_string_properties(*properties)
    properties.inject({}) do |memo, property_name|
      memo.merge(property_name => { "type" => "string" })
    end
  end

  def build_ref_properties(property_names, refname)
    property_names.inject({}) do |memo, property_name|
      memo.merge(property_name => {
        "$ref" => "#/definitions/#{refname}",
      })
    end
  end

  def build_publisher_schema(properties, link_names = nil, required_properties = nil)
    properties = build_string_properties(*properties)
    properties["links"] = build_publisher_links_schema(*link_names) if link_names
    definitions = build_string_properties("guid_list")
    build_schema("schema.json", properties: properties, required: required_properties, definitions: definitions)
  end

  def build_publisher_links_schema(*link_names)
    {
      "type" => "object",
      "additionalProperties" => false,
      "properties" => build_ref_properties(link_names, "guid_list"),
    }
  end

  def build_frontend_links_schema(*link_names)
    {
      "type" => "object",
      "additionalProperties" => false,
      "properties" => build_ref_properties(link_names, "frontend_links"),
    }
  end

  def build_base_links_schema(*link_names)
    schema = build_schema(
      "base_links.json",
      properties: build_ref_properties(link_names, "base_links"),
    )

    schema.schema["additionalProperties"] = false

    schema
  end
end
