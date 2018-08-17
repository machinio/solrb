module Solr
  module Query
    class Request
      class OrFilter
        def initialize(*filters)
          @filters = filters
        end

        def to_solr_s(core_name:)
          subexpressions = @filters.map { |f| "#{f.solr_field(core_name: core_name)}:(#{f.solr_value})" }
          "(#{subexpressions.join(' OR ')})"
        end
      end
    end
  end
end
