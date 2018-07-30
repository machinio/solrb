module Solr
  module SchemaHelper
    def solarize_field(field)
      Solr.configuration.field_map_function.call(field)
    end
  end
end
