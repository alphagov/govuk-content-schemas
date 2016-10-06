require "govuk_content_schemas"
require "json-schema"

module GovukContentSchemas::Utils
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
