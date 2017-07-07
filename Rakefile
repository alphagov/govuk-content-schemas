$LOAD_PATH << File.expand_path("../lib", __FILE__)

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

task build: [
              :regenerate_schemas,
              :validate_dist_schemas,
              :validate_uniqueness_of_frontend_example_base_paths,
              :validate_links,
              :validate_examples,
            ]

task default: [:build]

Dir.glob("lib/tasks/*.rake").each { |r| import r }
