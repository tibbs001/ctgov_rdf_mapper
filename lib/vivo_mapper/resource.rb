module VivoMapper
  class Resource

    attr_reader :stubbed

    def initialize
      @stubbed = false
    end

    def stub
      @stubbed = true
      self
    end

    def stub_for(attr_sym)
      stubbed_attr = self.send(attr_sym) if self.respond_to? attr_sym
      stubbed_attr ? stubbed_attr.stub : nil
    end

    def mapping
      self.class.mapping
    end

    def self.map_with(map)
      @mapping = map
    end

    def self.mapping
      @mapping
    end

  end
end
