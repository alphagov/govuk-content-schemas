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
    @frontend_schema = clone_schema(publisher_schema)
    remove_internal_properties!
    remove_internal_properties_from_required_properties!
    add_updated_at!
    ensure_frontend_links_definition!
    ensure_links_schema!
    transform_links_specification!
    add_available_translations_link!
    @frontend_schema
  end

private
  def internal?(property_name)
    INTERNAL_PROPERTIES.include?(property_name)
  end

  def remove_internal_properties!
    @frontend_schema.schema['properties'].reject! { |k, v| internal?(k) }
  end

  def remove_internal_properties_from_required_properties!
    return unless @frontend_schema.schema.has_key?('required')
    @frontend_schema.schema['required'].reject! { |property_name| internal?(property_name) }
  end

  def add_updated_at!
    @frontend_schema.schema['properties']['updated_at'] = {
      'type' => 'string',
      'format' => 'date-time'
    }
  end

  def ensure_frontend_links_definition!
    @frontend_schema.schema['definitions'] ||= {}
    @frontend_schema.schema['definitions']['frontend_links'] = frontend_links_definition
  end

  def ensure_links_schema!
    @frontend_schema.schema['properties']['links'] ||= {
      "type" => "object",
      "additionalProperties" => false,
      "properties" => {}
    }
  end

  def transform_links_specification!
    @frontend_schema.schema['properties']['links']['properties'].keys.each do |link_name|
      @frontend_schema.schema['properties']['links']['properties'][link_name] = {"$ref" => "#/definitions/frontend_links"}
    end
  end

  def add_available_translations_link!
    @frontend_schema.schema['properties']['links']['properties']['available_translations'] = {"$ref" => "#/definitions/frontend_links"}
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
