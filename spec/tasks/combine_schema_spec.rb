require 'spec_helper'
require 'rake'
require 'fileutils'

require 'govuk_content_schemas/schema_combiner'
require 'govuk_content_schemas/frontend_schema_generator'

RSpec::Matchers.define :exist do
  match { |actual| File.exist?(actual) }
end

RSpec.describe 'combine_schemas' do
  include_context "rake"
  let(:task_path) { "lib/tasks/combine_schemas" }

  let(:reader) { JSON::Schema::Reader.new(accept_file: true, accept_uri: false) }
  subject { rake[output_filename] }
  let(:format_name) { "my_format" }

  context "publisher schema" do
    let(:task_name) { "combine_publisher_schemas" }
    let(:generated_schema) { reader.read(output_filename) }
    let(:publisher_schema_dir) { project_root.join("formats", format_name, "publisher") }

    let(:schemas) {
      {
        metadata: reader.read(project_root.join("formats/metadata.json")),
        v1_metadata: reader.read(project_root.join("formats/v1_metadata.json")),
        v2_metadata: reader.read(project_root.join("formats/v2_metadata.json")),
        links_metadata: reader.read(project_root.join("formats/links_metadata.json")),
        definitions: reader.read(project_root.join("formats/definitions.json")),
        details: build_schema('details.json', properties: build_string_properties('detail')),
        links: build_schema('links.json', properties: build_string_properties('links')),
        base_links: reader.read(project_root.join("formats/base_links.json"))
      }
    }

    before(:each) do
      FileUtils.mkdir_p(publisher_schema_dir)
      File.write(publisher_schema_dir.join("details.json").to_s, schemas[:details].to_s)
      File.write(publisher_schema_dir.join("links.json").to_s, schemas[:links].to_s)

      subject.invoke
    end

    after(:each) do
      FileUtils.rm_r(project_root.join("formats", format_name))
      FileUtils.rm_r(project_root.join("dist/formats", format_name))
    end

    describe "publisher/schema.json" do
      let(:output_filename) { File.join("dist/formats", format_name, "publisher/schema.json") }

      it "produces a combined schema file at the specified output path" do
        expect(output_filename).to exist
      end

      it "derives the format name from the filesystem path" do
        expect(generated_schema.schema['properties']['format']).to eq(
          {"type" => "string", "enum" => [format_name]}
        )
      end

      specify "the schema.json file contains the combined schemas" do
        expected = GovukContentSchemas::SchemaCombiner.new(
          slice_hash(schemas, :definitions, :metadata, :v1_metadata, :base_links, :details, :links),
          format_name
        ).combined

        expect(generated_schema.schema).to eq(expected.schema)
      end
    end

    describe "publisher_v2/details.json" do
      let(:output_filename) { File.join("dist/formats", format_name, "publisher_v2/schema.json") }

      it "produces a combined schema file at the specified output path" do
        expect(output_filename).to exist
      end

      specify "the schema.json file contains the combined schemas" do
        expected = GovukContentSchemas::SchemaCombiner.new(
          slice_hash(schemas, :definitions, :metadata, :v2_metadata, :details),
          format_name
        ).combined

        expect(generated_schema.schema).to eq(expected.schema)
      end
    end

    describe "publisher_v2/links.json" do
      let(:output_filename) { File.join("dist/formats", format_name, "publisher_v2/links.json") }

      it "produces a combined schema file at the specified output path" do
        expect(output_filename).to exist
      end

      specify "the schema.json file contains the combined schemas" do
        expected = GovukContentSchemas::SchemaCombiner.new(
          slice_hash(schemas, :definitions, :links_metadata, :base_links, :links),
          format_name
        ).combined

        expect(generated_schema.schema).to eq(expected.schema)
      end
    end
  end

  context "frontend schema" do
    let(:publisher_schema_dir) { project_root.join("dist", "formats", format_name, "publisher") }
    let(:publisher_schema) { build_publisher_schema(%w{body details}, %{related}) }
    let(:publisher_schema_filename) { File.join("dist/formats", format_name, "publisher/schema.json") }
    let(:output_filename) { File.join("dist/formats", format_name, "frontend/schema.json") }
    let(:frontend_links_definition) { reader.read("formats/frontend_links_definition.json") }

    let(:task_name) { "combine_frontend_schemas" }

    before(:each) {
      FileUtils.mkdir_p(publisher_schema_dir)
      File.write(publisher_schema_filename, publisher_schema.to_s)

      subject.invoke
    }

    after(:each) do
      FileUtils.rm_r(project_root.join("dist/formats", format_name))
    end

    it "produces an frontend schema output file" do
      expect(output_filename).to exist
    end

    specify "the frontend schema file contains a frontend schema" do
      actual = reader.read(output_filename)
      expected = GovukContentSchemas::FrontendSchemaGenerator.new(publisher_schema, frontend_links_definition).generate

      expect(actual.schema).to eq(expected.schema)
    end
  end
end
