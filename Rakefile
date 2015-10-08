begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

task :make do
  sh "make clean && make"
end

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
    if File.exists?(destination)
      puts "\tSkipping #{destination} because it already exists"
    else
      FileUtils.cp("templates/#{file}", destination)
    end
  end
end

task :default => [:spec, :make]
