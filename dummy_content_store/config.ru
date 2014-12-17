#\ -p 3068
$LOAD_PATH << File.dirname(__FILE__) + "/lib"
require 'dummy_content_store/app'

examples_path = ENV['EXAMPLES_PATH'] || File.dirname(__FILE__) + "/../formats"

map '/content' do
  run DummyContentStore::App.new(examples_path)
end
