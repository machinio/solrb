module Solr
  module Query
    class Request
      class Boosting
        class FieldValueLessThanBoostFunction
          include Solr::Support::SchemaHelper

          attr_reader :core_name, :field, :max, :boost_magnitude

          def initialize(core_name:, field:, max:, boost_magnitude:)
            @core_name = core_name
            @field = field
            @max = max
            @boost_magnitude = boost_magnitude
            freeze
          end

          def to_solr_s
            solr_field = solarize_field(core_name: core_name, field: field)
            "if(sub(#{max},max(#{solr_field},#{max})),1,#{boost_magnitude})"
          end
        end
      end
    end
  end
end
