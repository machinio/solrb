module Solr
  module FieldConfiguration
    class Field
      attr_reader :name, :field_type, :dynamic_field_name_mapping, :solr_field

      def initialize(name:, field_type:, dynamic_field_name_mapping: true, solr_field: nil)
        @name = name
        @field_type = field_type
        @dynamic_field_name_mapping = dynamic_field_name_mapping
        @solr_field = solr_field
      end

      def solr_field_name
        field = solr_field || name

        if field_type.dynamic? && dynamic_field_name_mapping
          field_type.solr_definition.gsub('*', field.to_s)
        else
          field.to_s
        end
      end
    end
  end
end
