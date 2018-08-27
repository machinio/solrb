module Solr
  module Query
    class Request
      class Boosting
        class RankingFieldBoostFunction
          include Solr::Support::SchemaHelper
          attr_reader :field

          def initialize(field:)
            @field = field
          end

          def to_solr_s
            solarize_field(field).to_s
          end
        end
      end
    end
  end
end
