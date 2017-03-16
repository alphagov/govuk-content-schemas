require "pathname"
require "json-schema"

module SchemaBuilderHelpers
  def project_root
    Pathname.new(File.expand_path("../../", __dir__))
  end

  def build_schema(name, properties: nil, definitions: nil, required: nil)
    schema = {
      "$schema" => "http://json-schema.org/draft-04/schema#",
      "type" => "object"
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
        "$ref" => "#/definitions/#{refname}"
      })
    end
  end

  def build_publisher_schema(properties, required_properties: nil, link_names: [], required_link_names: [])
    properties = build_string_properties(*properties)
    properties["links"] = { "$ref" => "#/definitions/links" }
    definitions = { "links" => build_publisher_links_properties(link_names, required_link_names) }
    build_schema("schema.json", properties: properties, required: required_properties, definitions: definitions)
  end

  def build_publisher_links_schema(link_names)
    properties = build_string_properties(%w[previous_version])
    properties["links"] = build_publisher_links_properties(link_names)
    definitions = build_string_properties("guid_list")
    build_schema("links.json", properties: properties, definitions: definitions)
  end

  def build_publisher_links_properties(link_names, required_link_names = [])
    properties = {
      "type" => "object",
      "additionalProperties" => false,
      "properties" => build_ref_properties(link_names, "guid_list"),
    }
    properties["required"] = required_link_names unless required_link_names.empty?
    properties
  end

  def build_frontend_links_properties(link_names, required_link_names = [])
    definitions = link_names.each_with_object({}) do |name, memo|
      memo[name] = a_hash_including("$ref" => "#/definitions/frontend_links")
    end
    properties = {
      "type" => "object",
      "additionalProperties" => false,
      "properties" => definitions,
    }
    properties["required"] = required_link_names unless required_link_names.empty?
    properties
  end

  def build_base_links_schema(*link_names)
    schema = build_schema(
      "base_links.json",
      properties: build_ref_properties(link_names, "base_links"),
    )

    schema.schema["additionalProperties"] = false

    schema
  end

  def slice_hash(hash, *keys)
    keys.each_with_object({}) { |k, h| h[k] = hash[k] if hash.has_key?(k) }
  end
end
