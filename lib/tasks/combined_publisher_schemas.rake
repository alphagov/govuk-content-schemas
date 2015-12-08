require 'govuk_content_schemas/schema_combiner'
require 'json-schema'
require 'json'

READER = JSON::Schema::Reader.new(accept_file: true, accept_uri: false)

combine_schemas = ->(task) do
  source_schemas = Hash[task.sources.map { |s| [s.pathmap("%n").to_sym, READER.read(s)] }]
  format_name = task.name.pathmap("%{dist/formats/,}d").pathmap("%d")

  combiner = GovukContentSchemas::SchemaCombiner.new(source_schemas, format_name)

  File.open(task.name, 'w') do |file|
    file.write JSON.pretty_generate(combiner.combined.schema)
  end
end

def sources_for_v1_schema(filename)
  Rake::FileList.new(
    "formats/{definitions,metadata,v1_metadata,base_links}.json",
    filename.pathmap("%{^dist/,}p").pathmap("%d/{details,links}.json")
  )
end

def sources_for_v2_details(filename)
  Rake::FileList.new(
    "formats/{definitions,metadata,v2_metadata}.json",
    filename.pathmap("%{^dist/,}p").pathmap("%{_v2,}d/details.json")
  )
end

def sources_for_v2_links(filename)
  Rake::FileList.new(
    "formats/{definitions,links_metadata,base_links}.json",
    filename.pathmap("%{^dist/,}p").pathmap("%{_v2,}d/links.json")
  )
end

rule %r{^dist/formats/.*/publisher/schema.json} => ->(f) { sources_for_v1_schema(f) }, &combine_schemas
rule %r{^dist/formats/.*/publisher_v2/schema.json} => ->(f) { sources_for_v2_details(f) }, &combine_schemas
rule %r{^dist/formats/.*/publisher_v2/links.json} => ->(f) { sources_for_v2_links(f) }, &combine_schemas

hand_made_publisher_schemas = FileList.new("formats/*/publisher/schema.json").pathmap("%d")
generated_formats = FileList.new("formats/*/publisher").exclude(*hand_made_publisher_schemas)

task combined_publisher_v1_schemas: generated_formats.pathmap("dist/%p/schema.json")
task combined_publisher_v2_schemas: generated_formats.pathmap("dist/%p_v2/schema.json")
# Some formats don't have source v2 links.json files. Exclude them so we don't generate generic
# links.json files in dist
task combined_publisher_v2_links: generated_formats.exclude { |f| !File.exist?("#{f}/links.json") }
  .pathmap("dist/%p_v2/links.json")

task combined_publisher_schemas: %i{
  combined_publisher_v1_schemas
  combined_publisher_v2_schemas
  combined_publisher_v2_links
}
