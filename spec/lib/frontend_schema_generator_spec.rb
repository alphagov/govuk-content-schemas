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

  let(:link_names) { ["lead_organisations"] }

  let(:required_properties) {
    %w{
      base_path
      format
      locale
      publishing_app
      update_type
    }
  }

  let(:publisher_schema) {
    build_publisher_schema(publisher_properties - ['links'], link_names, required_properties)
  }

  subject(:generated) {
    described_class.new(publisher_schema).generate
  }

  it "removes disallowed properties from the top level properties list" do
    disallowed_properties.each do |disallowed_property|
      expect(generated.schema['properties'].keys).to_not include(disallowed_property)
    end
  end

  it "removes disallowed properties top level list of required properties" do
    disallowed_properties.each do |disallowed_property|
      expect(generated.schema['required']).to_not include(disallowed_property)
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

  it "injects a frontend_links definition" do
    expect(generated.schema['definitions']).to include('frontend_links')
    expect(generated.schema['definitions']['frontend_links']['type']).to eq('array')
  end

  it "transforms the links specification to allow expanded links and available_tranlsations" do
    expect(generated.schema['properties']['links']).to eq(build_frontend_links_schema(*link_names, 'available_translations'))
  end

  context "no links in publisher schema" do
    let(:link_names) { nil }

    it "transforms the links specification to allow available_tranlsations" do
      expect(generated.schema['properties']['links']).to eq(build_frontend_links_schema('available_translations'))
    end
  end
end
