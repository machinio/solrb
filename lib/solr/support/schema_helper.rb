module Solr
  module Support
    module SchemaHelper
      def solarize_field(core: nil, field:)
        core = core_config_by_core(core)
        field_config = core.field_by_name(field.to_sym) if core
        field_config ? field_config.solr_field_name : field.to_s
      end

      private

      def core_config_by_core(core)
        core_config = Solr.configuration.cores[core.to_sym] if core
        core_config ||= Solr.configuration.cores[nil] if Solr.configuration.cores.has_key?(nil)
        core_config ||= Solr.configuration.default_core if Solr.configuration.cores.count == 1
        core_config
      end
    end
  end
end
