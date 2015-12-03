require 'govuk_content_schemas/schema_combiner'

RSpec.describe GovukContentSchemas::SchemaCombiner do
  let(:metadata_schema) { build_schema('metadata.json', properties: build_string_properties('body')) }
  let(:definitions) { build_schema('definitions.json', definitions: build_string_properties('def1')) }
  let(:base_links) { build_schema('base_links.json', properties: build_ref_properties(["mainstream_browse_pages"], 'guid_list')) }
  let(:format_name) { 'my_format' }

  subject(:combined) do
    described_class.new({
      definitions: definitions,
      metadata: metadata_schema,
      details: details_schema
    }, format_name).combined
  end

  context "combining a simple metadata and details schema" do
    let(:details_schema) { build_schema('details.json', properties: build_string_properties('detail')) }

    it 'adds a details property to the combined schema' do
      expect(combined.schema['properties']['details']).to be_a(Hash)
    end

    it 'explicitly defines the format name in the format property' do
      expect(combined.schema['properties']['format']).to eq(
        {
          "type" => "string",
          "enum" => [format_name]
        }
      )
    end

    it 'strips the $schema key from the embedded details property' do
      expect(combined.schema['properties']['details']).not_to have_key('$schema')
    end

    it 'embeds the remaining content of the details schema as the details property definition' do
      remaining_content_of_details_schema = details_schema.schema.reject { |k, v| k == '$schema'}
      expect(combined.schema['properties']['details']).to eq(remaining_content_of_details_schema)
    end

    it 'uses the original uri for the combined schema' do
      expect(combined.uri).to eq(metadata_schema.uri)
    end
  end

  context "combining schemas and definitions" do
    let(:definitions) {
      build_schema('definitions.json',
        definitions: build_string_properties('def1')
      )
    }
    let(:metadata_schema) {
      build_schema('metadata.json',
        properties: build_string_properties('body')
      )
    }

    let(:details_schema) {
      build_schema('details.json',
        properties: build_string_properties('detail'),
        definitions: build_string_properties('def2')
      )
    }

    subject(:combined) do
      described_class.new({
        metadata: metadata_schema,
        details: details_schema,
        definitions: definitions
      }, format_name).combined
    end

    it 'removes the definitions from the embedded details property' do
      expect(combined.schema['properties']['details']).not_to have_key('definitions')
    end

    it 'merges the definitions from the details schema into the top-level definitions' do
      expect(combined.schema['definitions']).to include('def1', 'def2')
      expect(combined.schema['definitions']['def2']).to eq(details_schema.schema['definitions']['def2'])
    end
  end

  context "combining a metadata schema and a links schema" do
    let(:links_schema) {
      build_schema('links.json',
        properties: build_string_properties('lead_organisations'),
        definitions: build_string_properties('guid_list')
      )
    }
    subject(:combined) do
      described_class.new({
        definitions: definitions,
        base_links: base_links,
        metadata: metadata_schema,
        links: links_schema
      }, format_name).combined
    end

    it 'adds a links property to the combined schema' do
      expect(combined.schema['properties']['links']).to be_a(Hash)
    end

    it 'strips the $schema key from the embedded links property' do
      expect(combined.schema['properties']['links']).not_to have_key('$schema')
    end

    it 'embeds the remaining content of the links schema as the links property definition' do
      remaining_content_of_links_schema = links_schema.schema.reject { |k, v| %w{$schema definitions}.include?(k) }
      expect(combined.schema['properties']['links']['properties'].keys).to eq(['lead_organisations', 'mainstream_browse_pages'])
    end

    it 'merges the definitions from the links schema into the combined schemas definitions' do
      expect(combined.schema['definitions']).to include('guid_list')
      expect(combined.schema['definitions']['guid_list']).to eq(links_schema.schema['definitions']['guid_list'])
    end
  end

  context "combining metadata and details for a v2 schema" do
    let(:metadata_schema) {
      build_schema('metadata.json',
                   properties: build_string_properties('body'),
                   required: ['content_id', 'body', 'update_type'])
    }

    let(:details_schema) {
      build_schema('details.json', properties: build_string_properties('detail'))
    }

    let(:links_schema) {
      build_schema('links.json', properties: build_string_properties('lead_organisations'))
    }

    let(:definitions) {
      build_schema('definitions.json', definitions: build_string_properties('def1', 'def2'))
    }

    subject(:combined) do
      described_class.new({
        definitions: definitions,
        metadata: metadata_schema,
        details: details_schema
      }, format_name).combined
    end

    it 'removes the definitions from the embedded details property' do
      expect(combined.schema['properties']['details']).not_to have_key('definitions')
    end

    it 'merges the definitions into the combined schema' do
      expect(combined.schema['definitions']).to include('def1', 'def2')
    end

    it "doesn't merge the links schema" do
      expect(combined.schema).not_to have_key('links')
    end

    it "removes update_type and content_id required properties" do
      expect(combined.schema['required']).not_to include('content_id')
      expect(combined.schema['required']).not_to include('update_type')
      expect(combined.schema['required']).to include('body')
    end

    it "removes update_type and content_id properties" do
      expect(combined.schema['properties']).not_to have_key('content_id')
      expect(combined.schema['properties']).not_to have_key('update_type')
    end
  end

  context "combining links and definitions for a v2 schema" do
    let(:links_schema) {
      build_schema('links.json', properties: build_string_properties('lead_organisations', 'mainstream_browse_pages'))
    }

    let(:definitions) {
      build_schema('definitions.json', definitions: build_string_properties('guid_list'))
    }

    let(:base_links) { build_schema('base_links.json', properties: build_ref_properties(['organisations', 'parent'], 'guid_list')) }

    subject(:combined) do
      described_class.new({
        definitions: definitions,
        base_links: base_links,
        links: links_schema
      }, format_name).combined
    end

    it 'preserves $schema key' do
      expect(combined.schema).to have_key('$schema')
    end

    it 'embeds the remaining content of the links schema as the links property definition' do
      remaining_content_of_links_schema = links_schema.schema.reject { |k, v| %w{$schema definitions}.include?(k) }
      expect(combined.schema['properties'].keys).to match_array(['lead_organisations', 'mainstream_browse_pages', 'organisations', 'parent'])
    end

    it 'merges the definitions from the definitions schema into the combined schemas definitions' do
      expect(combined.schema['definitions']).to include('guid_list')
      expect(combined.schema['definitions']['guid_list']).to eq(definitions.schema['definitions']['guid_list'])
    end
  end
end
