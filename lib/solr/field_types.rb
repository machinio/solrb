module Solr
  class FieldTypes
    attr_accessor :types

    def initialize
      @types = {}
    end

    def type(name, opts = {})
      types[name] = Solr::FieldType.new(name, opts)
    end

    def [](type)
      types[type]
    end
  end
end
