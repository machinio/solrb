module Solr
  module Support
    module SchemaHelper
      def solarize_field(field:)
        core = Solr.current_core_config
        field_config = core.field_by_name(field.to_sym) if core
        field_config ? field_config.solr_field_name : field.to_s
      end
    end
  end
end
