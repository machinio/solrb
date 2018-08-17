module Solr
  module Query
    class Request
      class Boosting
        class ScaleFunctionBoost
          include Solr::Support::SchemaHelper

          attr_reader :field, :min, :max

          def initialize(field:, min:, max:)
            @field = field
            @min = min
            @max = max
            freeze
          end

          def to_solr_s(core_name:)
            "scale(#{solr_field(core_name: core_name)},#{min},#{max})"
          end

          def solr_field(core_name:)
            solarize_field(core_name: core_name, field: field)
          end
        end
      end
    end
  end
end
