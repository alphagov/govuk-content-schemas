source "https://rubygems.org"

ruby File.read(".ruby-version").chomp

gem "jsonnet", "~>0.4.0" # Version 0.5 (current latest) does not currently compile on our CI machines
gem "json-schema"
gem "rake"
gem "rspec"

group :test do
  gem "pry-byebug"
  gem "simplecov"
end

group :development, :test do
  gem "rubocop-govuk"
end
