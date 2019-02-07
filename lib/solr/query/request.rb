require 'solr/query/request/facet'
require 'solr/query/request/filter'
require 'solr/query/request/boost_magnitude'
require 'solr/query/request/geo_filter'
require 'solr/query/request/sorting'
require 'solr/query/request/edismax_adapter'
require 'solr/query/request/grouping'
require 'solr/query/request/boosting'
require 'solr/query/request/spellcheck'
require 'solr/query/request/sorting/field'
require 'solr/query/request/sorting/function'
require 'solr/query/request/field_with_boost'
require 'solr/query/request/or_filter'
require 'solr/query/request/and_filter'
require 'solr/query/handler'

module Solr
  module Query
    class Request
      attr_reader :search_term
      attr_accessor :filters, :fields, :facets, :boosting, :debug_mode, :spellcheck,
                    :limit_docs_by_field, :phrase_slop, :response_fields, :query_operator
      attr_writer :grouping, :sorting

      def initialize(search_term:, fields: [], filters: [])
        @search_term = search_term
        @fields = fields
        @filters = filters
      end

      def run(page: 1, page_size: 10)
        Solr::Query::Handler.call(query: self, page: page, page_size: page_size)
      end

      def grouping
        @grouping ||= Solr::Query::Request::Grouping.none
      end

      def sorting
        @sorting ||= Solr::Query::Request::Sorting.none
      end

      def to_h
        Solr::Query::Request::EdismaxAdapter.new(self).to_h
      end
    end
  end
end
