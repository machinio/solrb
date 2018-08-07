module Solr
  module FieldConfiguration
    class FieldDefinitionBuilder
      attr_reader :dynamic_fields, :fields_params

      def initialize
        @dynamic_fields = {}
        @fields_params = {}
      end

      def dynamic_field(name, solr_name:)
        dynamic_fields[name] = Solr::FieldConfiguration::DynamicField.new(name: name, solr_name: solr_name)
      end

      def field(name, params = {})
        fields_params[name] = params
      end

      def build
        fields_params.inject({}) do |fields, (name, params)|
          fields[name] = 
            Solr::FieldConfiguration::Field.new(name: name,
                                                solr_name: params[:solr_name],
                                                dynamic_field: get_dynamic_field(name, params[:dynamic_field]))
          fields
        end
      end

      def get_dynamic_field(field_name, dynamic_field_name)
        dynamic_field = dynamic_fields[dynamic_field_name]

        if dynamic_field_name && !dynamic_field
          raise "Field '#{field_name}' is mapped to an undefined dynamic field '#{dynamic_field_name}'"
        end

        dynamic_field
      end
    end
  end
end
