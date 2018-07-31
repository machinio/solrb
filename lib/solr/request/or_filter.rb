module Solr
  class Request
    class OrFilter
      def initialize(*filters)
        @filters = filters
      end

      def to_solr_s
        subexpressions = @filters.map { |f| "#{f.solr_field}:(#{f.solr_value})" }
        "(#{subexpressions.join(' OR ')})"
      end
    end
  end
end
