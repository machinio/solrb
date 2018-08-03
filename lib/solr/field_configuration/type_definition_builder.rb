module Solr
  module FieldConfiguration
    class TypeDefinitionBuilder
      attr_reader :field_types

      def initialize
        @field_types = {}
      end

      # TODO Add support for regular fields
      def dynamic_field_type(name, solr_definition:)
        field_types[name] = Solr::FieldConfiguration::DynamicFieldType.new(name: name, solr_definition: solr_definition)
      end

      def build
        field_types
      end
    end
  end
end
