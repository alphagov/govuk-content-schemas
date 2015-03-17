require 'spec_helper'
require 'tmpdir'
require 'fileutils'

RSpec.describe 'ensure_exaple_base_paths_unique' do
  let(:executable_path) {
    Pathname.new('../../bin/ensure_example_base_paths_unique').expand_path(File.dirname(__FILE__))
  }

  let(:tmpdir) { Pathname.new(Dir.mktmpdir) }

  def generate_example(name, base_path)
    example_path = tmpdir + name
    File.write(example_path, JSON.dump({"base_path" => base_path}))
    example_path
  end

  def invoke_ensure_example_base_paths_unique(*arguments)
    cmd = ([executable_path.to_s] + arguments.map { |a| %Q("#{a}") } + ["2>&1"]).join(" ")
    @output = `#{cmd}`
    $?.success?
  end

  after(:each) { FileUtils.remove_entry_secure(tmpdir) }

  context "all examples have unique base_paths" do
    let(:examples) {
      [
        generate_example("a.json", "/letter_a"),
        generate_example("b.json", "/letter_b")
      ]
    }

    it "exits with zero exit status" do
      succeeded = invoke_ensure_example_base_paths_unique(*examples)
      expect(succeeded).to be_truthy
    end
  end

  context "some examples have duplicate base_paths" do
    let(:examples) {
      [
        generate_example("a.json", "/letter_a"),
        generate_example("b.json", "/letter_a")
      ]
    }

    it "exits with non-zero exit status" do
      succeeded = invoke_ensure_example_base_paths_unique(*examples)
      expect(succeeded).to be_falsy
    end

    it "outputs a list of the duplicates" do
      invoke_ensure_example_base_paths_unique(*examples)
      expect(@output).to include("a.json")
      expect(@output).to include("b.json")
    end
  end
end
