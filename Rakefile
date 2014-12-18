begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

task :make do
  sh "make"
end

task :default => [:spec, :make]

