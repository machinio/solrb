module Solr
  module Query
    class Request
      class Boosting
        class LnFunctionBoost
          include Solr::Support::SchemaHelper

          attr_reader :core_name, :field, :min, :boost_magnitude

          def initialize(core_name:, field:, min: 0.69, boost_magnitude: 1)
            @core_name = core_name
            @field = field
            @min = min
            @boost_magnitude = boost_magnitude
            freeze
          end

          def to_solr_s
            "mul(if(gt(#{solr_field},1),ln(#{solr_field}),#{min}),#{boost_magnitude})"
          end

          def solr_field
            solarize_field(core_name: core_name, field: field)
          end
        end
      end
    end
  end
end
