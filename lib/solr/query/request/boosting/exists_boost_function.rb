module Solr
  module Query
    class Request
      class Boosting
        class ExistsBoostFunction
          include Solr::SchemaHelper

          attr_reader :field, :boost_magnitude

          def initialize(field:, boost_magnitude:)
            @field = field
            @boost_magnitude = boost_magnitude
            freeze
          end

          def to_solr_s
            "if(exists(#{solr_field}),#{boost_magnitude},1)"
          end

          def solr_field
            solarize_field(field)
          end
        end
      end
    end
  end
end
