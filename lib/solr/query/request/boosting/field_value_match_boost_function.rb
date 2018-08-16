module Solr
  module Query
    class Request
      class Boosting
        class FieldValueMatchBoostFunction
          include Solr::Support::SchemaHelper

          attr_reader :core_name, :field, :value, :boost_magnitude

          def initialize(core_name: field:, value:, boost_magnitude:)
            @core_name = core_name
            @field = field
            @value = value
            @boost_magnitude = boost_magnitude
            freeze
          end

          def solr_field
            solarize_field(core_name: core_name, field: field)
          end
        end
      end
    end
  end
end
