module Solr
  module FieldConfiguration
    class FieldDefinitionBuilder
      attr_reader :available_field_types, :fields

      def initialize(available_field_types)
        @available_field_types = available_field_types
        @fields = {}
      end

      def field(name, type, dynamic_field_name_mapping: true, solr_field: nil)
        field_type = available_field_types[type]
        raise "Field type #{type} was not defined." unless field_type
        field_opts = { name: name,
                      field_type: field_type,
                      dynamic_field_name_mapping: dynamic_field_name_mapping,
                      solr_field: solr_field }
        fields[name] = Solr::FieldConfiguration::Field.new(field_opts)
      end

      def build
        fields
      end
    end
  end
end
