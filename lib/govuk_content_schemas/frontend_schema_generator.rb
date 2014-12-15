require 'govuk_content_schemas'
require 'govuk_content_schemas/utils'
require 'json-schema'

class GovukContentSchemas::FrontendSchemaGenerator
  include ::GovukContentSchemas::Utils

  attr_reader :publisher_schema

  ALLOWED_PROPERTIES = %w{
    base_path
    title
    description
    format
    need_ids
    locale
    updated_at
    public_updated_at
    details
    links
  }.freeze

  def initialize(publisher_schema)
    @publisher_schema = publisher_schema
  end

  def generate
    frontend_schema = clone_schema(publisher_schema)
    remove_disallowed_properties!(frontend_schema)
    remove_disallowed_required_properties!(frontend_schema)
    add_updated_at!(frontend_schema)
    ensure_frontend_links_definition!(frontend_schema)
    ensure_links_schema!(frontend_schema)
    transform_links_specification!(frontend_schema)
    add_available_translations_link!(frontend_schema)
    frontend_schema
  end

private
  def remove_disallowed_properties!(schema)
    schema.schema['properties'].select! { |k, v| allowed?(k) }
  end

  def remove_disallowed_required_properties!(schema)
    return unless schema.schema.has_key?('required')
    schema.schema['required'].select! { |property_name| allowed?(property_name) }
  end

  def add_updated_at!(schema)
    schema.schema['properties']['updated_at'] = {
      'type' => 'string',
      'format' => 'date-time'
    }
  end

  def ensure_frontend_links_definition!(schema)
    schema.schema['definitions'] ||= {}
    schema.schema['definitions']['frontend_links'] = frontend_links_definition
  end

  def ensure_links_schema!(schema)
    schema.schema['properties']['links'] ||= {
      "type" => "object",
      "additionalProperties" => false,
      "properties" => {}
    }
  end

  def transform_links_specification!(schema)
    schema.schema['properties']['links']['properties'].keys.each do |link_name|
      schema.schema['properties']['links']['properties'][link_name] = {"$ref" => "#/definitions/frontend_links"}
    end
  end

  def add_available_translations_link!(schema)
    schema.schema['properties']['links']['properties']['available_translations'] = {"$ref" => "#/definitions/frontend_links"}
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
          "locale" => { "type" => "string" },
        }
      }
    }
  end

  def allowed?(property_name)
    ALLOWED_PROPERTIES.include?(property_name)
  end

  def expand_links
  end
end
