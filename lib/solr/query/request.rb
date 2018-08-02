module Solr
  module Query
    class Request
      FORM_URLENCODED_CONTENT_TYPE = 'application/x-www-form-urlencoded; charset=UTF-8'.freeze
      SOLR_SELECT_PATH = '/select'.freeze

      include Solr::UrlUtils

      attr_reader :page, :page_size, :solr_params

      class << self
        def run(opts)
          new(opts).run
        end
      end

      def initialize(page:, page_size:, solr_params: {})
        @page = page
        @page_size = page_size
        @solr_params = solr_params
      end

      def run
        response = connection.post_as_json(request_params)
        response = JSON.parse(response.body)
        # Solr::Testing.set_last_solr_request_response(request_params, response)
        response
      end

      private

      def start
        start_page = @page.to_i - 1
        start_page = start_page < 1 ? 0 : start_page
        start_page * page_size
      end

      def connection
        Solr::Connection.new(solr_url(SOLR_SELECT_PATH))
      end

      def request_params
        # https://lucene.apache.org/solr/guide/7_1/json-request-api.html#passing-parameters-via-json
        { params: solr_params.merge({ wt: :json, rows: page_size.to_i, start: start }) }
      end
    end
  end
end
