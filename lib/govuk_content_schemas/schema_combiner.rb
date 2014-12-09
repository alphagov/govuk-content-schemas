require 'govuk_content_schemas'
require 'json-schema'

class GovukContentSchemas::SchemaCombiner
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
    cloned = clone_hash(embeddable.schema)
    cloned.reject { |k, v| %w{$schema definitions}.include?(k) }
  end

  def combine_definitions
    combined = clone_hash(metadata_schema.schema.fetch('definitions', {}))
    [details_schema, links_schema].compact.inject(combined) do |memo, embedded_schema|
      memo.merge(embedded_schema.schema.fetch('definitions', {}))
    end
  end

  def clone_hash(hash)
    Marshal.load(Marshal.dump(hash))
  end

  def clone_schema(schema)
    parse_schema(schema.to_s, schema.uri)
  end

  def parse_schema(body, uri)
    JSON::Schema.new(JSON::Validator.parse(body), uri)
  end
end
