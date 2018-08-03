module Solr
  module FieldConfiguration
    class DynamicFieldDefinitionBuilder
      attr_reader :field_types

      def initialize
        @field_types = {}
      end

      def dynamic_field(name, solr_definition:)
        field_types[name] = Solr::FieldConfiguration::DynamicField.new(name: name, solr_definition: solr_definition)
      end

      def build
        field_types
      end
    end
  end
end
