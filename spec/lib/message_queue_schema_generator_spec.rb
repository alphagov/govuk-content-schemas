require 'govuk_content_schemas/message_queue_schema_generator'

RSpec.describe GovukContentSchemas::MessageQueueSchemaCombiner do
  include GovukContentSchemas::Utils

  let(:message_queue_base_schema) {
    build_message_queue_base_schema("schema_name", "document_type")
  }

  let(:definitions_schema) {
    build_schema('definitions.json', definitions: build_string_properties('def1'))
  }

  let(:details_schema) {
    build_schema('details.json', properties: build_string_properties('detail'))
  }

  let(:base_links_schema) {
    build_base_links_schema('base_links.json', "policies")
  }

  subject {
    described_class.new.combine(
      message_queue_base_schema,
      definitions_schema,
      base_links_schema,
      {
        "format_foo" => details_schema,
        "format_bar" => nil,
      },
    )
  }

  it "includes format_foo in the details definition" do
    expect(
      subject.schema["definitions"]["details"]["definitions"]["format_foo"]
    ).to eq(details_schema.schema)
  end

  it "does not include format_bar in the details definition" do
    expect(
      subject.schema["definitions"]["details"]["definitions"]
    ).not_to have_key("format_bar")
  end

  it "references format_foo in the formats definition" do
    expect(
      subject.schema["definitions"]["formats"]["oneOf"]
    ).to include(
      "type" => "object",
      "properties" => a_hash_including(
        "details" => {
          "$ref" => "#/definitions/details/definitions/format_foo",
        }
      )
    )
  end

  it "does not reference details for format_bar in the formats definition" do
    oneOf = subject.schema["definitions"]["formats"]["oneOf"]

    matching_schemas = oneOf.select { |schema|
      schema["properties"]["format"]["enum"].first == "format_bar"
    }

    expect(matching_schemas.length).to eq(1)

    matching_schema = matching_schemas.first

    expect(matching_schema["properties"]).to_not have_key("details")
  end

  it "includes format definitions for format_foo and format_bar" do
    oneOf = subject.schema["definitions"]["formats"]["oneOf"]

    ["format_foo", "format_bar"].each do |format|
      expect(oneOf).to include(
        "type" => "object",
        "properties" => a_hash_including(
          "schema_name" => {
            "enum" => [format],
          },
          "format" => {
            "enum" => [format],
          },
        ),
      )
    end
  end
end
