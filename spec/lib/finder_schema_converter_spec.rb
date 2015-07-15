require 'govuk_content_schemas/finder_schema_converter'

RSpec.describe GovukContentSchemas::FinderSchemaConverter do
  let(:converter) { GovukContentSchemas::FinderSchemaConverter.new }
  subject(:converted) { converter.call(*input_files) }

  context "converting single finder schema" do
    let(:schema) {
      {
        "document_noun" => "example",
        "facets" => facets
      }
    }
    let(:facets) { [facet] }
    let(:tmpdir) { Pathname.new(Dir.mktmpdir) }
    let(:schema_file) { tmpdir + "schema.json" }
    let(:input_files) { [schema_file] }

    before(:each) {
      File.write(schema_file, JSON.dump(schema))
    }

    after(:each) { FileUtils.remove_entry_secure(tmpdir) }

    context "no facets" do
      let(:facets) { [] }
      let(:document_type_name) { "my_random_document_type"}
      let(:schema_file) { tmpdir + "#{document_type_name}.json" }

      it "derives the definition name from the file name" do
        expect(converted['definitions'].keys).to eq(["#{document_type_name}_metadata"])
      end
    end

    context "single select facet" do
      let(:facet) {
        {
          "key" => "aircraft_category",
          "name" => "Aircraft category",
          "type" => "text",
          "preposition" => "in aircraft category",
          "display_as_result_metadata" => true,
          "filterable" => true,
          "allowed_values" => [
            {"label" => "Commercial - fixed wing", "value" => "commercial-fixed-wing"},
            {"label" => "Commercial - rotorcraft", "value" => "commercial-rotorcraft"},
            {"label" => "General aviation - fixed wing", "value" => "general-aviation-fixed-wing"},
            {"label" => "General aviation - rotorcraft", "value" => "general-aviation-rotorcraft"},
            {"label" => "Sport aviation and balloons", "value" => "sport-aviation-and-balloons"}
          ]
        }
      }

      subject(:aircraft_category) { converted["definitions"]["schema_metadata"]["properties"]["aircraft_category"] }
      let(:multiplicity_identifier) { double(:multiplicity_identifier) }
      let(:converter) { GovukContentSchemas::FinderSchemaConverter.new(select_field_multiplicity_identifier: multiplicity_identifier) }

      context "select_field_multiplicity_identifier identifies the field as a single select" do
        let(:multiplicity_identifier) { ->(document_type, facet_name) { false } }

        it "generates a field which matches a string constrained by the allowed_values" do
          expect(aircraft_category).to eq(
            {
              "type" => "string",
              "enum" => [
                "commercial-fixed-wing",
                "commercial-rotorcraft",
                "general-aviation-fixed-wing",
                "general-aviation-rotorcraft",
                "sport-aviation-and-balloons"
              ]
            }
          )
        end
      end

      context "select_field_multiplicity_identifier identifies the field as a single select" do
        let(:multiplicity_identifier) { ->(document_type, facet_name) { true } }

        it "generates a field which matches a array whose elements are constrained by the allowed_values" do
          expect(aircraft_category).to eq(
            {
              "type" => "array",
              "items" => {
                "type" => "string",
                "enum" => [
                  "commercial-fixed-wing",
                  "commercial-rotorcraft",
                  "general-aviation-fixed-wing",
                  "general-aviation-rotorcraft",
                  "sport-aviation-and-balloons"
                ]
              }
            }
          )
        end
      end
    end

    context "date facet" do
      let(:facet) {
        {
          "key" => "date_of_occurrence",
          "name" => "Date of occurrence",
          "short_name" => "Occurred",
          "type" => "date",
          "preposition" => "occurred",
          "display_as_result_metadata" => true,
          "filterable" => true
        }
      }

      it "generates a string schema with a pattern matching YYYY-MM-DD" do
        expect(converted).to eq(
          "definitions" => {
            "schema_metadata" => {
              "type" => "object",
              "additionalProperties" => false,
              "properties" => {
                "document_type" => {
                  "type" => "string",
                  "enum" => ["schema"]
                },
                "date_of_occurrence" => {
                  "type" => "string",
                  "pattern" => "^[1-9][0-9]{3}-(0[1-9]|1[0-2])-([012][0-9]|3[0-1])$"
                }
              }
            }
          }
        )
      end
    end

    context "text facet" do
      let(:facet) {
        {
          "key" => "aircraft_type",
          "name" => "Aircraft type",
          "type" => "text",
          "display_as_result_metadata" => false,
          "filterable" => false
        }
      }

      it "generates a simple string input" do
        expect(converted).to eq(
          "definitions" => {
            "schema_metadata" => {
              "type" => "object",
              "additionalProperties" => false,
              "properties" => {
                "document_type" => {
                  "type" => "string",
                  "enum" => ["schema"]
                },
                "aircraft_type" => {
                  "type" => "string"
                }
              }
            }
          }
        )
      end
    end

    context "given a mapper which can convert filenames to document_types" do
      let(:converter) { GovukContentSchemas::FinderSchemaConverter.new(document_type_mapper: document_type_mapper) }
      let(:document_type_mapper) {
        ->(file_name) { File.basename(file_name, ".json") + "_CONVERTED" }
      }

      let(:facet) {
        {
          "key" => "aircraft_type",
          "type" => "text"
        }
      }

      it "uses the mapper to generate the document_type and facet name" do
        expect(converted['definitions'].keys).to eq(["schema_CONVERTED_metadata"])
        expect(converted['definitions']["schema_CONVERTED_metadata"]["properties"]["document_type"]).to eq(
          "type" => "string",
          "enum" => ["schema_CONVERTED"]
        )
      end
    end
  end

  context "combining two files" do
    let(:schema) {
      {
        "document_noun" => "example",
        "facets" => [facet]
      }
    }
    let(:tmpdir) { Pathname.new(Dir.mktmpdir) }
    let(:schema_file1) { tmpdir + "schema1.json" }
    let(:schema_file2) { tmpdir + "schema2.json" }

    let(:input_files) { [schema_file1, schema_file2] }

    before(:each) {
      File.write(schema_file1, JSON.dump(schema))
      File.write(schema_file2, JSON.dump(schema))
    }

    after(:each) { FileUtils.remove_entry_secure(tmpdir) }

    let(:facet) {
      {
        "key" => "aircraft_category",
        "type" => "text",
      }
    }

    it "produces definitions for each format" do
      expect(converted["definitions"].keys).to eq(['schema1_metadata', 'schema2_metadata'])
    end
  end

  context "converting multiple files" do
    let(:input_files) {
      Dir[File.dirname(__FILE__) + "/../fixtures/finder_schemas/*.json"]
    }

    it "combines all of the facets from each file" do
      expect(converted['definitions'].keys).to eq(['aaib-reports_metadata', 'drug-safety-updates_metadata'])
      expect(converted['definitions']['aaib-reports_metadata']['properties'].keys).to eq(["document_type", "aircraft_category", "report_type", "date_of_occurrence", "aircraft_type", "location", "registration"])
      expect(converted['definitions']['drug-safety-updates_metadata']['properties'].keys).to eq(["document_type", "therapeutic_area", "first_published_at"])
    end
  end
end