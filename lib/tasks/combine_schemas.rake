require 'rake/clean'
require 'govuk_content_schemas/schema_combiner'
require 'govuk_content_schemas/frontend_schema_generator'
require 'json-schema'
require 'json'

CLEAN << "dist/formats"

schema_reader = JSON::Schema::Reader.new(accept_file: true, accept_uri: false)

hand_made_publisher_schemas = FileList.new("formats/*/publisher/schema.json")

rule %r{^dist/formats/.*/publisher(_v2)?/schema.json} => ->(f) { f.sub(%r{^dist/}, '') } do |t|
  FileUtils.mkdir_p t.name.pathmap("%d")
  FileUtils.cp t.source, t.name
end

task hand_made_publisher_schemas: hand_made_publisher_schemas.pathmap("dist/%p").add(
  hand_made_publisher_schemas.pathmap("dist/%p").pathmap("%{publisher,publisher_v2}p"))

def sources_for_v1_schema(filename)
  Rake::FileList.new(
    "formats/{definitions,metadata,v1_metadata,base_links}.json",
    filename.pathmap("%{^dist/,}p").pathmap("%d/{details,links,document_types}.json")
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
  ).select { |f| File.exist?(f) }
end

def sources_for_frontend_schema(filename)
  Rake::FileList.new(filename.pathmap("%{frontend,publisher}p"))
end

combine_publisher_schemas = ->(task) do
  source_schemas = Hash[task.sources.map { |s| [s.pathmap("%n").to_sym, schema_reader.read(s)] }]
  FileUtils.mkdir_p task.name.pathmap("%d")
  format_name = task.name.pathmap("%{dist/formats/,}d").pathmap("%d")

  combiner = GovukContentSchemas::SchemaCombiner.new(source_schemas, format_name)

  File.open(task.name, 'w') do |file|
    file.puts JSON.pretty_generate(combiner.combined.schema)
  end
end

combine_frontend_schemas = ->(task) do
  publisher_schema = schema_reader.read(task.sources.first)
  frontend_links_definition = schema_reader.read("formats/frontend_links_definition.json")

  FileUtils.mkdir_p task.name.pathmap("%d")
  generator = GovukContentSchemas::FrontendSchemaGenerator.new(publisher_schema, frontend_links_definition)

  File.open(task.name, 'w') do |file|
    file.puts JSON.pretty_generate(generator.generate.schema)
  end
end

rule %r{^dist/formats/.*/publisher/schema.json} => ->(f) { sources_for_v1_schema(f) }, &combine_publisher_schemas
rule %r{^dist/formats/.*/publisher_v2/schema.json} => ->(f) { sources_for_v2_details(f) }, &combine_publisher_schemas
rule %r{^dist/formats/.*/publisher_v2/links.json} => ->(f) { sources_for_v2_links(f) }, &combine_publisher_schemas

rule %r{^dist/formats/.*/frontend/schema.json} => ->(f) { sources_for_frontend_schema(f) }, &combine_frontend_schemas

generated_publisher_formats = FileList.new("formats/*/publisher").exclude(*hand_made_publisher_schemas.pathmap("%d"))
generated_frontend_formats = FileList.new("formats/*/frontend")

task combine_publisher_v1_schemas: generated_publisher_formats.pathmap("dist/%p/schema.json")
task combine_publisher_v2_schemas: generated_publisher_formats.pathmap("dist/%p_v2/schema.json")
task combine_publisher_v2_links: generated_publisher_formats.pathmap("dist/%p_v2/links.json")
task combine_frontend_schemas: generated_frontend_formats.pathmap("dist/%p/schema.json")

task combine_publisher_schemas: %i{
  hand_made_publisher_schemas
  combine_publisher_v1_schemas
  combine_publisher_v2_schemas
  combine_publisher_v2_links
}

task combine_schemas: %i{combine_publisher_schemas combine_frontend_schemas}
