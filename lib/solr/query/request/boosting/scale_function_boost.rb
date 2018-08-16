module Solr
  module Query
    class Request
      class Boosting
        class ScaleFunctionBoost
          include Solr::Support::SchemaHelper

          attr_reader :core_name, :field, :min, :max

          def initialize(core_name:, field:, min:, max:)
            @core_name = core_name
            @field = field
            @min = min
            @max = max
            freeze
          end

          def to_solr_s
            "scale(#{solr_field},#{min},#{max})"
          end

          def solr_field
            solarize_field(core_name: core_name, field: field)
          end
        end
      end
    end
  end
end
