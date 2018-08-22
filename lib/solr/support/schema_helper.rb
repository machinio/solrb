module Solr
  module Support
    module SchemaHelper
      def solarize_field(core_name: nil, field:)
        core = core_by_core_name(core_name)
        field_config = core.field_by_name(field.to_sym) if core
        field_config ? field_config.solr_field_name : field.to_s
      end

      private

      def core_by_core_name(core_name)
        core = Solr.configuration.cores[core_name.to_sym] if core_name
        core ||= Solr.configuration.default_core if Solr.configuration.cores.count == 1
        core
      end
    end
  end
end
