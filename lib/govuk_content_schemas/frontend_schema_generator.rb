require 'govuk_content_schemas'
require 'govuk_content_schemas/utils'
require 'json-schema'

class GovukContentSchemas::FrontendSchemaGenerator
  include ::GovukContentSchemas::Utils

  attr_reader :publisher_schema

  INTERNAL_PROPERTIES = %w{
    content_id
    publishing_app
    redirects
    rendering_app
    routes
    update_type
  }.freeze

  def initialize(publisher_schema)
    @publisher_schema = publisher_schema
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
    @publisher_schema.schema['required'].reject { |property_name| internal?(property_name) }
  end

  def frontend_properties
    (@publisher_schema.schema['properties'].reject { |property_name| internal?(property_name) }).tap do |properties|
      properties['links'] = frontend_links
      properties['updated_at'] = updated_at
    end
  end

  def publisher_links
    @publisher_schema.schema['properties']['links'].try(:clone) || {
      "type" => "object",
      "additionalProperties" => false,
      "properties" => {}
    }
  end

  def frontend_links
    publisher_links.tap do |links|
      links['properties'].keys.each do |link_name|
        links['properties'][link_name] = frontend_links_ref
      end
      links['properties']['available_translations'] = frontend_links_ref
    end
  end

  def publisher_definitions
    @publisher_schema.schema['definitions'].try(:clone) || {}
  end

  def frontend_definitions
    {
      'frontend_links' => frontend_links_definition
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

  def frontend_links_definition
    {
      "type" => "array",
      "items" => {
        "type" => "object",
        "additionalProperties" => false,
        "properties" =>  {
          "title" => { "type" => "string" },
          "base_path" => { "type" => "string" },
          "api_url" => { "type" => "string", "format" => "uri" },
          "web_url" => { "type" => "string", "format" => "uri" },
          "locale" => { "type" => "string" }
        }
      }
    }
  end

end
