module Solr
  class Response
    class FieldFacets
      include Enumerable

      attr_reader :field, :facet_values, :count, :subfacets

      def initialize(field:, facet_values:, count:, subfacets: [])
        @field        = field
        @facet_values = facet_values
        @count        = count
        @subfacets    = subfacets

        freeze
      end

      def each(&b)
        return enum_for(:each) unless block_given?
        facet_values.each(&b)
      end
    end
  end
end
