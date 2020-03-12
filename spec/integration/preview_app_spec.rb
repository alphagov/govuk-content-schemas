ENV["GOVUK_CONTENT_SCHEMAS_PATH"] = "."

require "rack/test"
require_relative "../../app"

RSpec.describe "Dummy content store rack application" do
  include Rack::Test::Methods

  it "serves the list of examples" do
    get "/"

    expect(last_response).to be_ok
  end

  it "serves random examples" do
    get "/api/content/examples/guide/random"

    expect(last_response).to be_ok
  end

  it "serves handwritten examples" do
    get "/api/content/examples/guide/guide"

    expect(last_response).to be_ok
  end

  it "serves handwritten examples with prefix routes" do
    get "/api/content/examples/guide/guide/key-stage-1-and-2"

    expect(last_response.location).to eql "http://example.org/api/content/examples/guide/guide"
  end

  it "redirects to the real content store for everything else" do
    get "/api/content/some/thing/else"

    expect(last_response.location).to eql "https://www.gov.uk/api/content/some/thing/else"
  end

  def app
    Sinatra::Application
  end
end
