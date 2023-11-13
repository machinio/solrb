module Solr
  module Query
    class Request
      class QueryField
        include Solr::Support::SchemaHelper

        attr_reader :field, :boost_magnitude

        def initialize(field:, boost_magnitude: Solr::Query::Request::BoostMagnitude::DEFAULT)
          @field = field
          @boost_magnitude = boost_magnitude
        end

        def to_solr_s
          if boost_magnitude == Solr::Query::Request::BoostMagnitude::DEFAULT
            solr_field
          else
            "#{solr_field}^#{boost_magnitude}"
          end
        end

        def solr_field
          solarize_field(@field)
        end
      end
    end
  end
end
