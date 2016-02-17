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

    it 'adds a details property to the combined schema definitions' do
      expect(combined.schema['definitions']['details']).to be_a(Hash)
    end

    it 'duplicates the metadata to add format and document_type/schema_name options' do
      expect(combined.schema).not_to have_key('properties')
      prop1 = combined.schema['oneOf'][0]['properties']
      expect(prop1.keys).to include('format')
      prop2 = combined.schema['oneOf'][1]['properties']
      expect(prop2.keys).to include('schema_name', 'document_type')
      expect(prop1.keys - ['format']).to eq(prop2.keys - ['document_type', 'schema_name'])
    end

    it 'explicitly defines the format name in the format property' do
      expect(combined.schema['oneOf'][0]['properties']['format']).to eq(
        {
          "type" => "string",
          "enum" => [format_name]
        }
      )
    end

    it 'strips the $schema key from the embedded details property' do
      expect(combined.schema['definitions']['details']).not_to have_key('$schema')
    end

    it 'embeds the remaining content of the details schema as the details property definition' do
      remaining_content_of_details_schema = details_schema.schema.reject { |k, v| k == '$schema'}
      expect(combined.schema['definitions']['details']).to eq(remaining_content_of_details_schema)
    end

    it 'uses the original uri for the combined schema' do
      expect(combined.uri).to eq(metadata_schema.uri)
    end
  end

  context "combining v1 metadata with common metadata and details" do
    let(:v1_metadata) {
      build_schema('v1_metadata.json', properties: build_string_properties('bar'), required: ['bar'])
    }

    let(:details) { build_schema('details.json', properties: build_string_properties('detail'), definitions: {}) }

    subject(:combined) do
      described_class.new({
        definitions: definitions,
        metadata: metadata_schema,
        v1_metadata: v1_metadata,
        details: details
      }, format_name).combined
    end

    it "combines the v1 metadata with simple metadata and details and adds the format" do
      expect(combined.schema['oneOf'][0]['properties'].keys).to match_array(['bar', 'body', 'format'])
      expect(combined.schema['definitions']).to have_key('details')
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
      expect(combined.schema['definitions']['details']).not_to have_key('definitions')
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
      expect(combined.schema['definitions']['links']).to be_a(Hash)
    end

    it 'strips the $schema key from the embedded links property' do
      expect(combined.schema['definitions']['links']).not_to have_key('$schema')
    end

    it 'embeds the remaining content of the links schema as the links property definition' do
      remaining_content_of_links_schema = links_schema.schema.reject { |k, v| %w{$schema definitions}.include?(k) }
      expect(combined.schema['definitions']['links']['properties'].keys).to eq(['lead_organisations', 'mainstream_browse_pages'])
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

    let(:v2_metadata) {
      build_schema('v2_metadata.json', properties: build_string_properties('foo'), required: ['foo'])
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
        v2_metadata: v2_metadata,
        details: details_schema
      }, format_name).combined
    end

    it 'removes the definitions from the embedded details property' do
      expect(combined.schema['definitions']['details']).not_to have_key('definitions')
    end

    it 'merges the definitions into the combined schema' do
      expect(combined.schema['definitions']).to include('def1', 'def2')
    end

    it "doesn't merge the links schema" do
      expect(combined.schema).not_to have_key('links')
    end

    it "merges in v2 required properties" do
      expect(combined.schema['oneOf'][0]['required']).to include('foo')
    end

    it "merges in v2 properties" do
      expect(combined.schema['oneOf'][0]['properties']).to have_key('foo')
    end
  end

  context "combining links and definitions for a v2 schema" do
    let(:links_metadata) {
      build_schema('links_metadata.json',
                   properties: build_string_properties('base_path'),
                   required: ['base_path'])
    }

    let(:base_links) {
      build_schema('base_links.json', properties: build_ref_properties(['organisations', 'parent'], 'guid_list'))
    }

    let(:links_schema) {
      build_schema('links.json', properties: build_string_properties('lead_organisations', 'mainstream_browse_pages'))
    }

    let(:definitions) {
      build_schema('definitions.json', definitions: build_string_properties('guid_list'))
    }

    subject(:combined) do
      described_class.new({
        links_metadata: links_metadata,
        definitions: definitions,
        base_links: base_links,
        links: links_schema
      }, format_name).combined
    end

    it 'preserves $schema key' do
      expect(combined.schema).to have_key('$schema')
    end

    it 'defines metadata properties' do
      expect(combined.schema['properties']).to have_key('base_path')
    end

    it 'defines required properties' do
      expect(combined.schema['required']).to include('base_path')
    end

    it 'embeds the merged links schemas as the links property' do
      remaining_content_of_links_schema = links_schema.schema.reject { |k, v| %w{$schema definitions}.include?(k) }
      expect(combined.schema['properties']['links']['properties'].keys).to match_array(
        ['lead_organisations', 'mainstream_browse_pages', 'organisations', 'parent'])
    end

    it 'merges the definitions from the definitions schema into the combined schemas definitions' do
      expect(combined.schema['definitions']).to include('guid_list')
      expect(combined.schema['definitions']['guid_list']).to eq(definitions.schema['definitions']['guid_list'])
    end
  end
end
