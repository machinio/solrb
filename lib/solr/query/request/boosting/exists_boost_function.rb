module Solr
  module Query
    class Request
      class Boosting
        class ExistsBoostFunction
          include Solr::Support::SchemaHelper

          attr_reader :core_name, :field, :boost_magnitude

          def initialize(core_name:, field:, boost_magnitude:)
            @core_name = core_name
            @field = field
            @boost_magnitude = boost_magnitude
            freeze
          end

          def to_solr_s
            "if(exists(#{solr_field}),#{boost_magnitude},1)"
          end

          def solr_field
            solarize_field(core_name: core_name, field: field)
          end
        end
      end
    end
  end
end
