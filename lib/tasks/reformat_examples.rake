require 'json'

task :reformat_examples do
  Dir.glob("formats/*/frontend/examples/*.json").each do |filename|
    data = JSON.parse(File.read(filename))

    File.write(filename, JSON.pretty_generate(data) + "\n")
  end
end
