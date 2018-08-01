module Solr
  class Entity
    def initialize(name)
      @name = name
      @fields = {}
    end

    def add_field(field)
      @fields[field.name] = field
    end

    private

    def method_missing(method_name, *_arguments)
      field = @fields[method_name.to_sym]
      return field if field
      super
    end
  end
end
