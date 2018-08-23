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

          def to_solr_s(core:)
            "scale(#{solr_field(core: core)},#{min},#{max})"
          end

          def solr_field(core:)
            solarize_field(core: core, field: field)
          end
        end
      end
    end
  end
end
