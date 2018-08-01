module Solr
  class Request
    class FieldWithBoost
      attr_reader :field, :boost_magnitude

      def initialize(field:, boost_magnitude: Solr::Request::BoostMagnitude::DEFAULT)
        @field = field
        @boost_magnitude = boost_magnitude
      end

      def to_solr_s
        "#{field}^#{boost_magnitude}"
      end
    end
  end
end
