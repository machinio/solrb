module Solr
  module Query
    class Request
      class AndFilter
        def initialize(*filters)
          @filters = filters
        end

        def to_solr_s
          subexpressions = @filters.map(&:to_solr_s)
          "(#{subexpressions.join(' AND ')})"
        end
      end
    end
  end
end
