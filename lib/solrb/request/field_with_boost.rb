module Solr
  class Request
    class FieldWithBoost
      attr_reader :field, :boost_magnitude

      def initialize(field:, boost_magnitude: Solr::Request::BoostMagnitude::DEFAULT)
        @field = field
        @boost_magnitude = boost_magnitude
      end

      def to_solr_s
        # TODO: This is very specific for machinio, make more generic
        solr_s = field.to_s.sub('_text', "_text_#{I18n.locale}")
        "#{solr_s}^#{boost_magnitude}"
      end
    end
  end
end
