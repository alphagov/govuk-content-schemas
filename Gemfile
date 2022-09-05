source "https://rubygems.org"

ruby File.read(".ruby-version").chomp

gem "json-schema"
gem "jsonnet"
gem "rake"
gem "rspec"

# Preview app for examples
gem "govuk_schemas"
gem "rack-test"
gem "sinatra"

group :test do
  gem "pry-byebug"
  gem "simplecov"
end

group :development, :test do
  gem "rubocop-govuk"
end
