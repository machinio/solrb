module Solr
  class TypeDefinitionBuilder
    attr_reader :field_types

    def initialize
      @field_types = {}
    end

    def dynamic_field_type(name, solr_definition:)
      field_types[name] = Solr::DynamicFieldType.new(name: name, solr_definition: solr_definition)
    end

    def build
      field_types
    end
  end
end
