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
require 'solr/query/request/field_with_boost'
require 'solr/query/request/or_filter'
require 'solr/query/request/runner'
require 'solr/query/response'
require 'solr/errors/solr_query_error'

module Solr
  module Query
    class Request
      attr_reader :search_term
      attr_accessor :filters, :fields, :facets, :boosting, :grouping, :sorting, :debug_mode, :spellcheck,
                    :limit_docs_by_field, :phrase_slop, :response_fields

      def initialize(search_term:, fields: [], filters: [])
        @search_term = search_term
        @fields = fields
        @filters = filters
      end

      # Runs this Solr::Request against Solr and
      # returns [Solr::Response]
      def run(page:, page_size:)
        solr_params = Solr::Query::Request::EdismaxAdapter.new(self).to_h
        solr_response = Solr::Query::Request::Runner.run(page: page, page_size: page_size, solr_params: solr_params)
        raise Errors::SolrQueryError, solr_response.error_message unless solr_response.ok?
        Solr::Query::Response::Parser.new(request: self, solr_response: solr_response.body).to_response
      end

      def grouping
        @grouping ||= Solr::Query::Request::Grouping.none
      end

      def sorting
        @sorting ||= Solr::Query::Request::Sorting.none
      end
    end
  end
end
