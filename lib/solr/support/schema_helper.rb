module Solr
  module SchemaHelper
    def solarize_field(field)
      field_config = Solr.configuration.fields[field.to_sym]
      if field_config
        field_config.solr_field_name
      else
        field.to_s
      end
    end
  end
end
