module Solr
  class Request
    class LimitDocsByField
      include Solr::SchemaHelper

      attr_reader :field, :min_pages

      def initialize(field:, min_pages:)
        @field = field
        @min_pages = min_pages
      end

      def to_solr_s
        "{!perPageLimit byField=#{solarize_field(field)} minPages=#{min_pages}}"
      end
    end
  end
end
