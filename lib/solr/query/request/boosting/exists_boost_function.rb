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

          def to_solr_s(core_name:)
            "if(exists(#{solr_field(core_name: core_name)}),#{boost_magnitude},1)"
          end

          def solr_field(core_name:)
            solarize_field(core_name: core_name, field: field)
          end
        end
      end
    end
  end
end
