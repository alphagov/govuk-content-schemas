require 'govuk_content_schemas'
require 'govuk_content_schemas/utils'
require 'json-schema'

class GovukContentSchemas::MessageQueueSchemaCombiner
  include ::GovukContentSchemas::Utils

  def combine(message_queue, common_definitions, links_schema, details_schemas)
    definitions = clone_hash(common_definitions.schema['definitions'])

    definitions['details'] = make_details_definition(details_schemas)
    definitions['formats'] = make_formats_definition(details_schemas)
    definitions['links'] = links_schema.schema

    message_queue.schema['definitions'] = definitions

    message_queue
  end

private

  def make_formats_definition(details_schemas)
    one_of = []

    details_schemas.each do |detail_name, schema|
      sub_schema = {
        "properties" => {
          "schema_name" => {
            "enum" => [detail_name],
          },
          "format" => {
            "enum" => [detail_name],
          },
        },
      }

      # If a schema is available to validate the contents of details, include this
      if !schema.nil?
        sub_schema["properties"].merge!({
          "details" => {
            "$ref" => "#/definitions/details/definitions/#{detail_name}",
          },
        })
      end

      one_of.push(sub_schema)
    end

    {
      "oneOf" => one_of,
    }
  end

  def make_details_definition(details_schemas)
    definitions = {}

    details_schemas.each do |detail_name, schema|
      next if schema.nil?

      definitions[detail_name] = schema.schema
    end

    {
      "definitions" => definitions,
    }
  end
end
