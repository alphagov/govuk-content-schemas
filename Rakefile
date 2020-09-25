$LOAD_PATH << File.expand_path("lib", __dir__)

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError # rubocop:disable Lint/SuppressedException
end

desc "regenerate schemas and validate"
task build: %i[
  regenerate_schemas
  validate_dist_schemas
  validate_uniqueness_of_frontend_example_base_paths
  validate_links
  format_examples
  validate_examples
]

task default: %w[lint build]

Dir.glob("lib/tasks/*.rake").each { |r| import r }
