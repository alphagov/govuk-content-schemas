require 'govuk_content_schemas'
require 'govuk_content_schemas/utils'
require 'json-schema'

class GovukContentSchemas::SchemaCombiner
  include ::GovukContentSchemas::Utils

  attr_reader :metadata_schema, :details_schema, :links_schema

  def initialize(metadata_schema, details_schema: nil, links_schema: nil)
    @metadata_schema = metadata_schema
    @details_schema = details_schema
    @links_schema = links_schema
  end

  def combined
    combined = clone_schema(metadata_schema)
    combined.schema['properties']['details'] = embed(details_schema) if details_schema
    combined.schema['properties']['links'] = embed(links_schema) if links_schema
    combined.schema['definitions'] = combine_definitions if combine_definitions.any?
    combined
  end

private
  def embed(embeddable)
    excluded_top_level_keys = %w{$schema definitions}
    clone_hash(embeddable.schema).reject { |k, _|
      excluded_top_level_keys.include?(k)
    }
  end

  def combine_definitions
    combined = clone_hash(metadata_schema.schema.fetch('definitions', {}))
    [details_schema, links_schema].compact.inject(combined) do |memo, embedded_schema|
      memo.merge(embedded_schema.schema.fetch('definitions', {}))
    end
  end
end
