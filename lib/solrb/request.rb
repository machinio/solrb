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
      rsolr_params = Solr::Request::RSolrAdapter.new(self).to_h
      # TODO: Check if ActiveSupport::Notifications.instrument is available
      rsolr_response = ActiveSupport::Notifications.instrument('query.solr_request', rsolr_params: rsolr_params) do
        # We should use POST method to avoid GET HTTP 413 error (request entity too large)
        RSolr.current.paginate(page, page_size, 'select', data: rsolr_params, method: :post)
      end
      Solr::Response::RSolrAdapter.new(request: self, rsolr_response: rsolr_response).to_response
    end

    def grouping
      @grouping ||= Solr::Request::Grouping.none
    end

    def sorting
      @sorting ||= Solr::Request::Sorting.none
    end
  end
end
