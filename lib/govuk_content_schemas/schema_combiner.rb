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
      add_version_properties(combined_schema.schema)
      add_details(combined_schema.schema)
      add_links(combined_schema.schema, 'definitions')
      add_format_field(combined_schema.schema)
    else
      combined_schema = clone_schema(schemas.fetch(:links_metadata))
      add_version_properties(combined_schema.schema)
      add_details(combined_schema.schema)
      add_links(combined_schema.schema, 'properties')
    end

    add_combined_definitions(combined_schema.schema)

    combined_schema
  end

private

  def add_version_properties(schema)
    version_schema = schemas[:v1_metadata] || schemas[:v2_metadata]

    if version_schema
      version_schema = embeddable_schema(version_schema)

      if schema['required']
        schema['required'] = schema['required'] + version_schema['required']
      end

      schema['properties'] = schema['properties'].merge(version_schema['properties'])
    end
  end

  def add_details(schema)
    return unless schemas[:details]
    schema['definitions'] = schema.fetch('definitions', {}).merge({'details' => embeddable_schema(schemas[:details])})
  end

  def add_links(schema, target)
    return unless schemas.key?(:base_links)

    schema[target] = {} unless schema.key?(target)
    if schemas.key?(:links)
      schema[target]['links'] = merge_schemas(schemas[:links], schemas.fetch(:base_links))
    else
      schema[target]['links'] = embeddable_schema(schemas.fetch(:base_links))
    end
  end

  def merge_schemas(base_schema, other)
    merged_schema = embeddable_schema(base_schema)
    other = embeddable_schema(other)
    merged_schema['properties'] = merged_schema['properties'].merge(other['properties'])
    merged_schema
  end

  def add_format_field(schema)
    schema['properties']['document_type'] = document_type
    schema['properties']['schema_name'] = format_with_name
  end

  def format_with_name
    if format_name == "placeholder"
      {
        "type" => "string",
        "pattern" => "^(placeholder|placeholder_.+)$",
        "description" => "Should be of the form 'placeholder_my_format_name'. 'placeholder' is allowed for backwards compatibility.",
      }
    else
      {
        "type" => "string",
        "enum" => [format_name]
      }
    end
  end

  def document_type
    if schemas.key?(:document_types)
      schemas[:document_types].schema["properties"]["document_type"]
    else
      { "type" => "string" }
    end
  end

  def add_combined_definitions(schema)
    return unless definitions_from_all_schemas.any?
    schema['definitions'] = schema.fetch('definitions', {}).merge!(definitions_from_all_schemas)
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
