module Solr
  module FieldConfiguration
    class DynamicField
      attr_reader :name, :solr_name

      def initialize(name:, solr_name:)
        @name = name
        @solr_name = solr_name
        freeze
      end

      def build(name)
        solr_name.gsub('*', name.to_s)
      end
    end
  end
end
