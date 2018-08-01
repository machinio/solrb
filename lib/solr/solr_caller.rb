module Solr
  class SolrCaller
    FORM_URLENCODED_CONTENT_TYPE = 'application/x-www-form-urlencoded; charset=UTF-8'.freeze
    SOLR_SELECT_PATH = 'select'.freeze

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
        req.body = @solr_params.merge({ wt: :json, rows: @page_size.to_i, start: page })
        req.headers['Content-Type'] = FORM_URLENCODED_CONTENT_TYPE
      end

      JSON.parse(response.body)
    end

    private

    def page
      page = @page.to_i - 1
      page < 1 ? 0 : page
    end

    def get_connection
      Solr.get_connection
    end
  end
end
