module Solr
  class SolrCaller
    FORM_URLENCODED_CONTENT_TYPE = 'application/x-www-form-urlencoded; charset=UTF-8'.freeze
    SOLR_SELECT_PATH = 'select'.freeze

    attr_reader :page, :page_size, :solr_params

    class << self
      def call(opts)
        new(opts).call
      end
    end

    def initialize(page:, page_size:, solr_params: {})
      @page = page
      @page_size = page_size
      @solr_params = solr_params
    end

    def call
      response = get_connection.post do |req|
        req.url(SOLR_SELECT_PATH)
        req.body = @solr_params.merge({ wt: :json, rows: page_size.to_i, start: start })
        req.headers['Content-Type'] = FORM_URLENCODED_CONTENT_TYPE
      end

      response = JSON.parse(response.body)
      Solr::Testing.set_last_solr_request_response(request_params, response)
      response
    end

    private

    def start
      start_page = @page.to_i - 1
      start_page = start_page < 1 ? 0 : start_page
      start_page * page_size
    end

    def get_connection
      Solr.get_connection
    end

    def request_params
      solr_params.merge(page: page, page_size: page_size)
    end
  end
end
