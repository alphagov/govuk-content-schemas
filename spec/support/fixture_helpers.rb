module FixtureHelpers
  def fixture_path(name)
    Pathname.new('fixtures').expand_path(File.dirname(__FILE__)).join(name)
  end
end
