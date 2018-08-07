module Solr
  module Query
    class Response
      class FacetValue
        attr_reader :text, :count, :subfacets

        def initialize(text:, count:, subfacets: [])
          @text      = text
          @count     = count
          @subfacets = subfacets
          freeze
        end
      end
    end
  end
end