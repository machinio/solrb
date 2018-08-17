module Solr
  module Query
    class Request
      class Boosting
        class RecentFieldValueBoostFunction
          include Solr::Support::SchemaHelper

          attr_reader :field, :boost_magnitude, :max_age_days

          def initialize(field:, boost_magnitude:, max_age_days:)
            @field = field
            @boost_magnitude = boost_magnitude
            @max_age_days = max_age_days
            freeze
          end

          def to_solr_s(core_name:)
            solr_field = solarize_field(core_name: core_name, field: field)
            recip_max_age_days_ms = 1.0 / (max_age_days * 24 * 3600 * 1000)
            "mul(#{boost_magnitude},recip(ms(NOW,#{solr_field}),#{recip_max_age_days_ms},0.5,0.1))"
          end
        end
      end
    end
  end
end
