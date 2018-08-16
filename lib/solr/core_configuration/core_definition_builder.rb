module Solr
  module CoreConfiguration
    class CoreDefinitionBuilder
      attr_reader :name, :dynamic_fields, :fields_params

      def initialize(name:)
        @name = name
        @dynamic_fields = {}
        @fields_params = {}
      end

      def dynamic_field(field_name, solr_name:)
        dynamic_fields[field_name] = Solr::CoreConfiguration::DynamicField.new(name: field_name, solr_name: solr_name)
      end

      def field(field_name, params = {})
        fields_params[field_name] = params
      end

      def build
        fields_params.each_with_object({}) do |(name, params), fields|
          fields[name] =
            Solr::CoreConfiguration::Field.new(name: name,
                                                solr_name: params[:solr_name],
                                                dynamic_field: get_dynamic_field(name, params[:dynamic_field]))
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
