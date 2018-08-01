require 'solr/request/facet'
require 'solr/request/limit_docs_by_field'
require 'solr/request/filter'
require 'solr/request/boost_magnitude'
require 'solr/request/geo_filter'
require 'solr/request/sorting'
require 'solr/request/edismax_adapter'
require 'solr/request/grouping'
require 'solr/request/boosting'
require 'solr/request/spellcheck'
require 'solr/request/sorting/field'
require 'solr/request/field_with_boost'
require 'solr/request/or_filter'

module Solr
  class Request
    attr_reader :document_type, :search_term
    attr_accessor :filters, :fields, :facets, :boosting, :grouping, :sorting, :debug_mode, :spellcheck,
                  :limit_docs_by_field, :phrase_slop

    def initialize(document_type:, search_term:)
      @document_type = document_type
      @search_term = search_term
    end

    # Runs this Solr::Request against Solr and
    # returns [Solr::Response]
    def run(page:, page_size:)
      solr_params = Solr::Request::EdismaxAdapter.new(self).to_h
      solr_response = Solr.with_instrumentation('query.solr_request', solr_params: solr_params) do
        # We should use POST method to avoid GET HTTP 413 error (request entity too large)
        Solr::SolrCaller.call(page: page, page_size: page_size, solr_params: solr_params)
      end
      Solr::Response::Parser.new(request: self, solr_response: solr_response).to_response
    end

    def grouping
      @grouping ||= Solr::Request::Grouping.none
    end

    def sorting
      @sorting ||= Solr::Request::Sorting.none
    end
  end
end
