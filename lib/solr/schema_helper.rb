module Solr
  module SchemaHelper
    def solarize_field(field)
      solr_field = Solr.configuration.filter_field_map[field]
      # TODO looks very specific
      return "#{solr_field}_#{I18n.locale}" if solr_field.to_s.ends_with?('_text')
      solr_field
    end

    def desolarize_field(solr_field)
      Solr.configuration.inverse_filter_field_map[solr_field]
    end
  end
end
