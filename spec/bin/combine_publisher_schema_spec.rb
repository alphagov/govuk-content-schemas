require 'spec_helper'
require 'tmpdir'

require 'govuk_content_schemas/schema_combiner'

RSpec::Matchers.define :exist do
  match { |actual| actual.exist? }
end

RSpec.describe 'combine_publisher_schema' do
  let(:executable_path) {
    Pathname.new('../../bin/combine_publisher_schema').expand_path(File.dirname(__FILE__))
  }

  let(:tmpdir) { Pathname.new(Dir.mktmpdir) }

  let(:schemas) {
    {
      metadata: build_schema('metadata.json', properties: build_string_properties('body')),
      details: build_schema('details.json', properties: build_string_properties('detail')),
      links: build_schema('links.json', properties: build_string_properties('links'))
    }
  }

  before(:each) {
    schemas.each do |name, schema|
      File.write(tmpdir + "#{name}.json", schema.to_s)
    end
  }
  after(:each) { FileUtils.remove_entry_secure(tmpdir) }

  before(:each) do
    output = `#{executable_path} "#{tmpdir}" 2>&1`
    fail(output) unless $?.success?
    output
  end

  it "produces a schema.json file" do
    expect(tmpdir + "schema.json").to exist
  end

  specify "the schema.json file contains the combined schemas" do
    reader = JSON::Schema::Reader.new(accept_file: true, accept_uri: false)
    actual = reader.read(tmpdir + "schema.json")
    expected = GovukContentSchemas::SchemaCombiner.new(
      schemas[:metadata],
      details_schema: schemas[:details],
      links_schema: schemas[:links]
    ).combined

    expect(actual.schema).to eq(expected.schema)
  end
end
