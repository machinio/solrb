module Solr
  module SchemaHelper
    def solarize_field(field)
      Solr.configuration.field_map.fetch(field, field)
    end

    def desolarize_field(solr_field)
      Solr.configuration.inverse_filter_field_map[solr_field]
    end
  end
end
