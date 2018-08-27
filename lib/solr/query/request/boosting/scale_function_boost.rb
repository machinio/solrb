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

          def to_solr_s
            "scale(#{solr_field},#{min},#{max})"
          end

          def solr_field
            solarize_field(field)
          end
        end
      end
    end
  end
end
