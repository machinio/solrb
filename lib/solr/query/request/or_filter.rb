module Solr
  module Query
    class Request
      class OrFilter
        attr_reader :filters

        def initialize(*filters)
          @filters = filters
        end

        def to_solr_s
          subexpressions = @filters.map(&:to_solr_s)
          "(#{subexpressions.join(' OR ')})"
        end
      end
    end
  end
end
