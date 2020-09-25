require "spec_helper"
require "json"
require "rake"

RSpec.describe "validate" do
  include_context "rake"

  def generate_example(name, base_path)
    example_path = tmpdir + name
    File.write(example_path, JSON.dump("base_path" => base_path))
    example_path
  end

  let(:tmpdir) { Pathname.new(Dir.mktmpdir) }

  after(:each) { FileUtils.remove_entry_secure(tmpdir) }

  context "validate_uniqueness_of_frontend_example_base_paths" do
    let(:task_path) { "lib/tasks/validate" }
    let(:task_name) { "validate_uniqueness_of_frontend_example_base_paths" }

    context "all examples have unique base_paths" do
      let(:examples) do
        [
          generate_example("a.json", "/letter_a"),
          generate_example("b.json", "/letter_b"),
        ]
      end

      it "succeeds without exceptions" do
        expect { subject.invoke(examples) }.to_not raise_error
      end
    end

    context "some examples have duplicate base_paths" do
      let(:examples) do
        [
          generate_example("a.json", "/letter_a"),
          generate_example("b.json", "/letter_a"),
        ]
      end

      it "exits with non-zero exit status and outputs a list of the duplicates" do
        expect { subject.invoke(examples) }.to raise_error(SystemExit)
          .and output(/a.json.*b.json/m).to_stderr
      end
    end
  end
end
