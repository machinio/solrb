module Solr
  module Query
    class Request
      class Boosting
        class LnFunctionBoost
          include Solr::Support::SchemaHelper

          attr_reader :field, :min, :boost_magnitude

          def initialize(field:, min: 0.69, boost_magnitude: 1)
            @field = field
            @min = min
            @boost_magnitude = boost_magnitude
            freeze
          end

          def to_solr_s(core_name:)
            "mul(if(gt(#{solr_field(core_name: core_name)},1),ln(#{solr_field(core_name: core_name)}),#{min}),#{boost_magnitude})"
          end

          def solr_field(core_name:)
            solarize_field(core_name: core_name, field: field)
          end
        end
      end
    end
  end
end
