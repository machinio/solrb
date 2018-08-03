module Solr
  module FieldConfiguration
    class DynamicFieldType
      attr_reader :name, :solr_definition

      def initialize(name:, solr_definition:)
        @name = name
        @solr_definition = solr_definition
        freeze
      end

      def dynamic?
        true
      end
    end
  end
end
