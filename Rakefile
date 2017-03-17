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
              :reformat_authored_json,
              :validate_shared_details_definitions,
              :validate_source_schemas,
            ]

desc "creates the folders and files for adding a new format"
task :new_format, [:format_name] do |_task, args|
  format_path = "formats/#{args[:format_name]}"
  template_files = %w(details.json links.json)

  FileUtils.mkdir_p(format_path)
  FileUtils.mkdir_p("#{format_path}/frontend")
  FileUtils.mkdir_p("#{format_path}/frontend/examples")
  FileUtils.mkdir_p("#{format_path}/publisher")

  template_files.each do |file|
    destination = "#{format_path}/publisher/#{file}"
    if File.exist?(destination)
      puts "\tSkipping #{destination} because it already exists"
    else
      FileUtils.cp("templates/#{file}", destination)
    end
  end
end

task default: [:build]

Dir.glob("lib/tasks/*.rake").each { |r| import r }
