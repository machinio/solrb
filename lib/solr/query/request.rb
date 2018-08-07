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

module Solr
  module Query
    class Request
      attr_reader :document_type, :search_term
      attr_accessor :filters, :fields, :facets, :boosting, :grouping, :sorting, :debug_mode, :spellcheck,
                    :limit_docs_by_field, :phrase_slop

      def initialize(document_type:, search_term:)
        @document_type = document_type
        @search_term = search_term
        @filters = []
        @fields = []
      end

      # Runs this Solr::Request against Solr and
      # returns [Solr::Response]
      def run(page:, page_size:)
        solr_params = Solr::Query::Request::EdismaxAdapter.new(self).to_h
        raw_response = Solr::Query::RequestRunner.run(page: page, page_size: page_size, solr_params: solr_params)
        Solr::Response::Parser.new(request: self, solr_response: raw_response).to_response
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
