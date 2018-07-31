module Solr
  class Request
    class Boosting
      class LnFunctionBoost
        include Solr::SchemaHelper

        attr_reader :field, :min, :boost_magnitude

        def initialize(field:, boost_magnitude: 1)
          @field = field
          @min = 0.69
          @boost_magnitude = boost_magnitude
          freeze
        end

        def to_solr_s
          # TODO understand this and extract if necessary
          "mul(if(gt(#{solr_field},1),ln(#{solr_field}),#{min}),#{boost_magnitude})"
        end

        def solr_field
          solarize_field(field)
        end
      end
    end
  end
end
