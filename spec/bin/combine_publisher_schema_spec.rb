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

  let(:format_name) { "my_format" }
  let(:tmpdir) { Pathname.new(Dir.mktmpdir) }
  let(:publisher_schema_dir) { tmpdir + format_name + "publisher" }
  let(:output_filename) { publisher_schema_dir + "my-generated-schema.json" }

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
    output = `#{executable_path} "#{publisher_schema_dir}" "#{output_filename}" 2>&1`
    fail(output) unless $?.success?
    output
  end

  it "produces a combined schema file at the specified output path" do
    expect(output_filename).to exist
  end

  def read_generated_schema
    reader = JSON::Schema::Reader.new(accept_file: true, accept_uri: false)
    reader.read(output_filename)
  end

  it "derives the format name from the filesystem path" do
    expect(read_generated_schema.schema['properties']['format']).to eq(
      {"type" => "string", "enum" => [format_name]}
    )
  end

  specify "the schema.json file contains the combined schemas" do
    expected = GovukContentSchemas::SchemaCombiner.new(
      schemas[:metadata],
      format_name,
      details_schema: schemas[:details],
      links_schema: schemas[:links]
    ).combined

    expect(read_generated_schema.schema).to eq(expected.schema)
  end
end
