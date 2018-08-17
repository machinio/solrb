module Solr
  module Support
    module SchemaHelper
      def solarize_field(core_name:, field:)
        field_config = Solr.configuration.cores.dig(core_name.to_sym, field.to_sym)
        if field_config
          field_config.solr_field_name
        else
          field.to_s
        end
      end
    end
  end
end
