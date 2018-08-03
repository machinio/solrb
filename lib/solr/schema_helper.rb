module Solr
  module SchemaHelper
    def solarize_field(field)
      solr_field = Solr.configuration.fields.fetch(field.to_sym)
      solr_field.solr_field_name
    end
  end
end
