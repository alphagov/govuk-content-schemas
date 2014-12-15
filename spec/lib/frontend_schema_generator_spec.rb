require 'govuk_content_schemas/frontend_schema_generator'

RSpec.describe GovukContentSchemas::FrontendSchemaGenerator do

  let(:allowed_properties) {
    %w{
      base_path
      description
      details
      format
      links
      locale
      need_ids
      public_updated_at
      title
      updated_at
    }
  }

  let(:publisher_properties) {
    %w{
      base_path
      content_id
      description
      details
      format
      links
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

  let(:disallowed_properties) {
    publisher_properties - allowed_properties
  }

  let(:links_schema) {
    {
      "type" => "object",
      "properties" => {
        "lead_organisations" => {
          "$ref" => "#/definitions/guid_list"
        }
      }
    }
  }

  let(:publisher_schema) {
    properties = build_string_properties(*publisher_properties).merge("links" => links_schema)
    definitions = build_string_properties('guid_list')
    build_schema('schema.json', properties, definitions)
  }

  subject(:generated) {
    described_class.new(publisher_schema).generate
  }

  it "removes disallowed properties from the top level properties list" do
    disallowed_properties.each do |disallowed_property|
      expect(generated.schema['properties'].keys).to_not include(disallowed_property)
    end
  end

  it "adds updated_at as an allowed datetime property" do
    expect(generated.schema['properties']).to include(
      "updated_at" => {
        "type" => "string",
        "format" => "date-time"
      }
    )
  end

  it "transforms the links specification to allow expanded links" do
    expect(generated.schema['properties']['links']).to eq({
      "type" => "object",
      "properties" => {
        "lead_organisations" => {
          "$ref" => "#/definitions/frontend_link"
        }
      }
    })
  end
end
