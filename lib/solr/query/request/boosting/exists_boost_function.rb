module Solr
  module Query
    class Request
      class Boosting
        class ExistsBoostFunction
          include Solr::Support::SchemaHelper

          attr_reader :field, :boost_magnitude

          def initialize(field:, boost_magnitude:)
            @field = field
            @boost_magnitude = boost_magnitude
            freeze
          end

          def to_solr_s(core:)
            "if(exists(#{solr_field(core: core)}),#{boost_magnitude},1)"
          end

          def solr_field(core:)
            solarize_field(core: core, field: field)
          end
        end
      end
    end
  end
end
