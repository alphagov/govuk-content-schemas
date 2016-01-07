require 'govuk_content_schemas'
require 'govuk_content_schemas/utils'
require 'json-schema'

class GovukContentSchemas::FrontendSchemaGenerator
  include ::GovukContentSchemas::Utils

  attr_reader :publisher_schema, :frontend_links_definition

  INTERNAL_PROPERTIES = %w{
    access_limited
    publishing_app
    redirects
    rendering_app
    routes
    update_type
  }.freeze

  def initialize(publisher_schema, frontend_links_definition)
    @publisher_schema = publisher_schema
    @frontend_links_definition = frontend_links_definition
  end

  def generate
    JSON::Schema.new({
      "$schema" => "http://json-schema.org/draft-04/schema#",
      "type" => "object",
      "additionalProperties" => false,
      "required" => required_properties,
      "properties" => frontend_properties,
      "definitions" => publisher_definitions.merge(frontend_definitions)
    }, @publisher_schema.uri)
  end

private
  def internal?(property_name)
    INTERNAL_PROPERTIES.include?(property_name)
  end

  def required_properties
    return [] unless @publisher_schema.schema.has_key?('required')
    ['base_path'] + (@publisher_schema.schema['required'] - INTERNAL_PROPERTIES)
  end

  def frontend_properties
    properties = @publisher_schema.schema['properties']
    properties = properties.reject { |property_name| internal?(property_name) }
    properties = resolve_multiple_content_types(properties)

    properties = properties.merge(
      'links' => frontend_links,
      'updated_at' => updated_at,
      'base_path' => { '$ref' => '#/definitions/absolute_path' }
    )

    properties
  end

  def frontend_link_names
    links = @publisher_schema.schema['properties'].fetch('links', {'properties' => {}})
    links.fetch('properties', {}).keys + ['available_translations']
  end

  def frontend_link_properties
    frontend_link_names.inject({}) do |hash, link_name|
      hash.merge(link_name => frontend_links_ref)
    end
  end

  def frontend_links
    clone_hash(@publisher_schema.schema['properties']['links'] || {}).merge(
      "additionalProperties" => false,
      "type" => "object",
      "properties" => frontend_link_properties
    )
  end

  def publisher_definitions
    clone_hash(@publisher_schema.schema['definitions']) || {}
  end

  def frontend_definitions
    {
      'frontend_links' => frontend_links_definition.schema.reject { |k| k == '$schema' }
    }
  end

  def updated_at
    {
      'type' => 'string',
      'format' => 'date-time'
    }
  end

  def frontend_links_ref
    {"$ref" => "#/definitions/frontend_links"}
  end

  def multiple_content_types_ref
    { "$ref" => "#/definitions/multiple_content_types" }
  end

  def resolve_multiple_content_types(object)
    if object == multiple_content_types_ref
      { "type" => "string" }
    elsif object.is_a?(Hash)
      object.each.with_object({}) do |(key, value), hash|
        hash.merge!(key => resolve_multiple_content_types(value))
      end
    elsif object.is_a?(Array)
      object.map { |element| resolve_multiple_content_types(element) }
    else
      object
    end
  end
end
