$LOAD_PATH << File.expand_path('../lib', File.dirname(__FILE__))

module FixtureHelper
  def fixture_path(name)
    Pathname.new('fixtures').expand_path(File.dirname(__FILE__)).join(name)
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!

  config.warnings = false

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.order = :random
  Kernel.srand config.seed

  config.include FixtureHelper
end
