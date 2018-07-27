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
      solr_response = Solrb.with_instrumentation('query.solr_request', solr_params: solr_params) do
        # We should use POST method to avoid GET HTTP 413 error (request entity too large)
        Solrb::SolrCaller.call(page: page, page_size: page_size, solr_params: solr_params)
      end
      Solr::Response::EdismaxAdapter.new(request: self, solr_response: solr_response).to_response
    end

    def grouping
      @grouping ||= Solr::Request::Grouping.none
    end

    def sorting
      @sorting ||= Solr::Request::Sorting.none
    end
  end
end
