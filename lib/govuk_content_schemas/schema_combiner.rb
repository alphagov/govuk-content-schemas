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
    if schemas.key?(:metadata)
      combined_schema = clone_schema(schemas.fetch(:metadata))
      add_format_field(combined_schema.schema)
    else
      combined_schema = clone_schema(schemas.fetch(:base_links))
    end

    add_details(combined_schema.schema)
    add_links(combined_schema.schema)


    add_combined_definitions(combined_schema.schema)
    update_required_properties(combined_schema.schema)

    combined_schema
  end

private

  def add_details(schema)
    return unless schemas[:details]
    schema['properties']['details'] = embeddable_schema(schemas[:details])
  end

  def add_links(schema)
    return unless schemas.key?(:links) || schemas.key?(:base_links)

    if schemas.key?(:metadata)
      if schemas.key?(:links)
        schema['properties']['links'] = merge_schemas(schemas[:links], schemas.fetch(:base_links))
      else
        schema['properties']['links'] = embeddable_schema(schemas.fetch(:base_links))
      end
    else
      links_properties = embeddable_schema(schemas.fetch(:links))['properties']
      schema['properties'].merge!(links_properties)
    end
  end

  def merge_schemas(base_schema, other)
    merged_schema = embeddable_schema(base_schema)
    other = embeddable_schema(other)
    merged_schema['properties'] = merged_schema['properties'].merge(other['properties'])
    merged_schema
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

  # v2 schemas do not require these properties.
  def update_required_properties(schema)
    return if schemas.key?(:metadata) && schemas.key?(:base_links) # v1 schema

    if schema['required']
      schema['required'].delete('content_id')
      schema['required'].delete('update_type')
    end

    schema['properties'].delete('content_id')
    schema['properties'].delete('update_type')
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
    combined = clone_hash(schemas.fetch(:definitions).schema.fetch('definitions', {}))

    [schemas[:details], schemas[:links]].compact.inject(combined) do |memo, embedded_schema|
      memo.merge(embedded_schema.schema.fetch('definitions', {}))
    end
  end
end
