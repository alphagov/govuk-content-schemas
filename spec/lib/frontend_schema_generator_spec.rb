require "govuk_content_schemas/frontend_schema_generator"

RSpec.describe GovukContentSchemas::FrontendSchemaGenerator do
  include GovukContentSchemas::Utils

  let(:publisher_properties) {
    %w{
      base_path
      description
      details
      format
      locale
      need_ids
      public_updated_at
      publishing_app
      redirects
      rendering_app
      routes
      title
      update_type
    }
  }

  let(:links_schema_link_names) { ["organisations"] }
  let(:publisher_schema_link_names) { [] }
  let(:required_publisher_schema_link_names) { [] }

  let(:required_properties) {
    %w{
      format
      locale
      publishing_app
      update_type
    }
  }

  let(:publisher_schema) {
    build_publisher_schema(
      publisher_properties,
      required_properties: required_properties,
      link_names: publisher_schema_link_names,
      required_link_names: required_publisher_schema_link_names,
    )
  }

  let(:publisher_links) { build_publisher_links_schema(links_schema_link_names) }

  let(:frontend_links_definition) {
    build_schema("frontend_links.json", properties: build_string_properties("test"))
  }

  let(:format) {}

  subject(:generated) {
    described_class.new(publisher_schema, publisher_links, frontend_links_definition, format).generate
  }

  let(:internal_properties) {
    GovukContentSchemas::FrontendSchemaGenerator::INTERNAL_PROPERTIES
  }

  let(:frontend_links) {
    build_frontend_links_properties(
      publisher_schema_link_names + links_schema_link_names +
      GovukContentSchemas::FrontendSchemaGenerator::LINK_NAMES_ADDED_BY_PUBLISHING_API
    )
  }

  it "does not modify its input" do
    original = clone_schema(publisher_schema)

    generated

    expect(publisher_schema.schema).to eq(original.schema)
  end

  it "removes internal properties from the top level properties list" do
    internal_properties.each do |internal_property|
      expect(generated.schema["properties"].keys).to_not include(internal_property)
    end
  end

  it "removes internal properties from the top level list of required properties" do
    internal_properties.each do |internal_property|
      expect(generated.schema["required"]).to_not include(internal_property)
    end
  end

  it "adds updated_at as an allowed datetime property" do
    expect(generated.schema["properties"]).to include(
      "updated_at" => {
        "type" => "string",
        "format" => "date-time"
      }
    )
  end

  it "adds base_path as a required string property" do
    expect(generated.schema["properties"]).to include(
      "base_path" => {
        "$ref" => "#/definitions/absolute_path"
      }
    )
    expect(generated.schema["required"]).to include(
      "base_path"
    )
  end

  it "adds content_id as a required guid property" do
    expect(generated.schema["properties"]).to include(
      "content_id" => {
        "$ref" => "#/definitions/guid"
      }
    )
    expect(generated.schema["required"]).to include(
      "content_id"
    )
  end

  it "injects a frontend_links definition" do
    expect(generated.schema["definitions"]).to include("frontend_links")
    expected_embed = frontend_links_definition.schema.reject { |k| k == "$schema" }
    expect(generated.schema["definitions"]["frontend_links"]).to eq(expected_embed)
  end

  it "transforms the links specification to allow expanded links and links added by the publishing-api" do
    expect(generated.schema["properties"]["links"]).to match(frontend_links)
  end

  context "format requires change history" do
    let(:format) { "specialist_document" }
    let(:publisher_schema) {
      build_schema("schema.json",
                   definitions: { "details" => { "required" => [] } }
                  )
    }

    it "change history is added to the required fields" do
      required = generated.schema["definitions"]["details"]["required"]
      expect(required).to include("change_history")
    end
  end

  context "publisher schema specifies links" do
    let(:publisher_schema_link_names) { %w[topics consultations] }

    it "includes the links" do
      expect(generated.schema["properties"]["links"]["properties"]).to match(
        a_hash_including("topics", "consultations")
      )
    end
  end


  context "publisher schema specifies a required link" do
    let(:publisher_schema_link_names) { %w[topics] }
    let(:required_publisher_schema_link_names) { %w[topics] }

    it "preserves list of required items" do
      expect(generated.schema["properties"]["links"]["required"]).to eq(required_publisher_schema_link_names)
    end
  end

  context "a link schema does not exist" do
    let(:publisher_links) { nil }

    it "doesn't error" do
      expect { generated }.not_to raise_error
    end
  end

  context "no links in publisher or links schemas" do
    let(:publisher_schema_link_names) { [] }
    let(:links_schema_link_names) { [] }
    let(:expected) {
      build_frontend_links_properties(GovukContentSchemas::FrontendSchemaGenerator::LINK_NAMES_ADDED_BY_PUBLISHING_API)
    }

    it "transforms the links specification to allow for links added by publishing-api" do
      expect(generated.schema["properties"]["links"]).to match(expected)
    end
  end

  context "when the 'multiple_content_types' definition is used" do
    let(:nested_object) do
      {
        "type" => "object",
        "properties" => {
          "body" => {
            "$ref" => "#/definitions/multiple_content_types",
          }
        }
      }
    end

    let(:nested_array) do
      {
        "type" => "array",
        "items" => {
          "$ref" => "#/definitions/multiple_content_types",
        }
      }
    end

    let(:deeply_nested) do
      {
        "type" => "array",
        "items" => {
          "type" => "object",
          "properties" => {
            "body" => {
              "$ref" => "#/definitions/multiple_content_types",
            }
          }
        }
      }
    end

    let(:properties) do
      {
        "body" => {
          "$ref" => "#/definitions/multiple_content_types",
        },
        "nested_object" => nested_object,
        "nested_array" => nested_array,
        "deeply_nested" => deeply_nested,
      }
    end

    let(:publisher_schema) do
      build_schema("schema.json", properties: properties, definitions: {})
    end

    it "replaces the field's 'ref' with a 'type' of 'string'" do
      properties = generated.schema["properties"]
      expect(properties["body"]).to eq("type" => "string")

      nested_object_properties = properties["nested_object"]["properties"]
      expect(nested_object_properties["body"]).to eq("type" => "string")

      nested_array = properties["nested_array"]
      expect(nested_array["items"]).to eq("type" => "string")

      deeply_nested = properties["deeply_nested"]
      nested_object_properties = deeply_nested["items"]["properties"]
      expect(nested_object_properties["body"]).to eq("type" => "string")
    end
  end
end
