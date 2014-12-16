require 'spec_helper'
require 'tmpdir'
require 'fileutils'

require 'govuk_content_schemas/schema_combiner'

RSpec::Matchers.define :exist do
  match { |actual| actual.exist? }
end

RSpec.describe 'combine_publisher_schema' do
  let(:executable_path) {
    Pathname.new('../../bin/combine_publisher_schema').expand_path(File.dirname(__FILE__))
  }

  let(:tmpdir) { Pathname.new(Dir.mktmpdir) }
  let(:publisher_schema_dir) { tmpdir + "my_format/publisher" }

  let(:schemas) {
    {
      metadata: build_schema('metadata.json', properties: build_string_properties('body')),
      details: build_schema('details.json', properties: build_string_properties('detail')),
      links: build_schema('links.json', properties: build_string_properties('links'))
    }
  }

  before(:each) {
    File.write(tmpdir + "metadata.json", schemas[:metadata].to_s)
    FileUtils.mkdir_p(publisher_schema_dir)
    File.write(publisher_schema_dir + "details.json", schemas[:details].to_s)
    File.write(publisher_schema_dir + "links.json", schemas[:links].to_s)
  }
  after(:each) { FileUtils.remove_entry_secure(tmpdir) }

  before(:each) do
    output = `#{executable_path} "#{publisher_schema_dir}" 2>&1`
    fail(output) unless $?.success?
    output
  end

  it "produces a schema.json file" do
    expect(publisher_schema_dir + "schema.json").to exist
  end

  specify "the schema.json file contains the combined schemas" do
    reader = JSON::Schema::Reader.new(accept_file: true, accept_uri: false)
    actual = reader.read(publisher_schema_dir + "schema.json")
    expected = GovukContentSchemas::SchemaCombiner.new(
      schemas[:metadata],
      details_schema: schemas[:details],
      links_schema: schemas[:links]
    ).combined

    expect(actual.schema).to eq(expected.schema)
  end
end
