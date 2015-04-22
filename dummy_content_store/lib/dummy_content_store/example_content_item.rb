module DummyContentStore
  class ExampleContentItem
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def base_path
      data["base_path"]
    end

    def data
      JSON.parse(raw_data)
    end

    def raw_data
      File.read(path)
    end
  end
end
