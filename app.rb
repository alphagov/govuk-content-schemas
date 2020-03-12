require "sinatra"
require "govuk_schemas"

set :views, "preview_app"

get "/" do
  schema_examples = {}

  Dir.glob("examples/**/frontend/*.json").each do |filename|
    _, schema_name, _, example_file = filename.split("/")

    schema_examples[schema_name] ||= []

    schema_examples[schema_name] << {
      example_name: example_file.gsub(".json", ""),
      content_item: JSON.parse(File.read(filename)),
    }
  end

  erb :index, locals: { schema_examples: schema_examples }
end

get "/api/content/examples/:schema_name/random" do |schema_name|
  content_type :json

  content_item = GovukSchemas::RandomExample.for_schema(frontend_schema: schema_name)
  content_item["base_path"] = "/examples/#{schema_name}/random"
  content_item.to_json
end

get "/api/content/examples/:schema_name/:example_name" do |schema_name, example_name|
  content_type :json

  begin
    content_item = GovukSchemas::Example.find(schema_name, example_name: example_name)
    content_item["base_path"] = "/examples/#{schema_name}/#{example_name}"
    content_item.to_json
  rescue Errno::ENOENT
    status 404
    "Page not found. Perhaps you've mistyped the example name?"
  end
end

get "/api/content/examples/:schema_name/:example_name/:suffix" do |schema_name, example_name, _suffix|
  redirect "/api/content/examples/#{schema_name}/#{example_name}"
end

get "/api/content/*" do
  redirect "https://www.gov.uk/api/content/#{params[:splat].join('/')}"
end
