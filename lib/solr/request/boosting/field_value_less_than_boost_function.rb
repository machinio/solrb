module Solr
  class Request
    class Boosting
      class FieldValueLessThanBoostFunction
        include Solr::SchemaHelper

        attr_reader :field, :max, :boost_magnitude

        def initialize(field:, max:, boost_magnitude:)
          @field = field
          @max = max
          @boost_magnitude = boost_magnitude
          freeze
        end

        def to_solr_s
          solr_field = solarize_field(field)
          "if(sub(#{max},max(#{solr_field},#{max})),1,#{boost_magnitude})"
        end
      end
    end
  end
end
