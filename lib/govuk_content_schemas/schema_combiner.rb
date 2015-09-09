require 'govuk_content_schemas'
require 'govuk_content_schemas/utils'
require 'json-schema'

class GovukContentSchemas::SchemaCombiner
  include ::GovukContentSchemas::Utils

  attr_reader :format_name, :schemas

  def initialize(schemas, format_name)
    @schemas = schemas
    @format_name = format_name
  end

  def combined
    combined_schema = clone_schema(schemas.fetch(:metadata))

    add_details(combined_schema.schema)
    add_links(combined_schema.schema)
    add_format_field(combined_schema.schema)
    add_combined_definitions(combined_schema.schema)

    combined_schema
  end

private

  def add_details(schema)
    return unless schemas[:details]
    schema['properties']['details'] = embeddable_schema(schemas[:details])
  end

  def add_links(schema)
    return unless schemas[:links]
    schema['properties']['links'] = embeddable_schema(schemas[:links])
  end

  def add_format_field(schema)
    if format_name == "placeholder"
      schema['properties']['format'] = {
        "type" => "string",
        "pattern" => "^(placeholder|placeholder_.+)$",
        "description" => "Should be of the form 'placeholder_my_format_name'. 'placeholder' is allowed for backwards compatibility.",
      }
    else
      schema['properties']['format'] = {
        "type" => "string",
        "enum" => [format_name]
      }
    end
  end

  def add_combined_definitions(schema)
    return unless definitions_from_all_schemas.any?
    schema['definitions'] = definitions_from_all_schemas
  end

  def embeddable_schema(embeddable)
    excluded_top_level_keys = %w{$schema definitions}
    clone_hash(embeddable.schema).reject { |k, _|
      excluded_top_level_keys.include?(k)
    }
  end

  def definitions_from_all_schemas
    combined = clone_hash(schemas.fetch(:metadata).schema.fetch('definitions', {}))

    [schemas[:details], schemas[:links]].compact.inject(combined) do |memo, embedded_schema|
      memo.merge(embedded_schema.schema.fetch('definitions', {}))
    end
  end
end
