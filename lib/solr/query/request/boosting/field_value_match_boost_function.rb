module Solr
  module Query
    class Request
      class Boosting
        class FieldValueMatchBoostFunction
          include Solr::Support::SchemaHelper

          attr_reader :field, :value, :boost_magnitude

          def initialize(field:, value:, boost_magnitude:)
            @field = field
            @value = value
            @boost_magnitude = boost_magnitude
            freeze
          end

          def solr_field
            solarize_field(field)
          end
        end
      end
    end
  end
end
