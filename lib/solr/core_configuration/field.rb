module Solr
  module CoreConfiguration
    class Field
      attr_reader :name, :dynamic_field, :solr_name

      def initialize(name:, dynamic_field: nil, solr_name: nil)
        @name = name
        @dynamic_field = dynamic_field
        @solr_name = solr_name
        freeze
      end

      def solr_field_name
        return solr_name.to_s if solr_name
        return dynamic_field.build(name) if dynamic_field
        name.to_s
      end
    end
  end
end
