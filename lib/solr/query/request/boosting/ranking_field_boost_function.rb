module Solr
  module Query
    class Request
      class Boosting
        class RankingFieldBoostFunction
          include Solr::Support::SchemaHelper
          attr_reader :core_name, :field

          def initialize(core_name:, field:)
            @core_name = core_name
            @field = field
          end

          def to_solr_s
            solarize_field(core_name: core_name, field: field).to_s
          end
        end
      end
    end
  end
end
