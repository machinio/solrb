module Solr
  module Query
    class Request
      class FieldWithBoost
        attr_reader :field, :boost_magnitude

        def initialize(field:, boost_magnitude: Solr::Query::Request::BoostMagnitude::DEFAULT)
          @field = field
          @boost_magnitude = boost_magnitude
        end

        def to_solr_s(core_name:)
          "#{field}^#{boost_magnitude}"
        end
      end
    end
  end
end
