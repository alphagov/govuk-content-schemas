require 'json'

task :reformat_authored_json do
  Dir.glob("formats/**/*.json").each do |filename|
    data = JSON.parse(File.read(filename))

    File.write(filename, JSON.pretty_generate(data) + "\n")
  end
end
