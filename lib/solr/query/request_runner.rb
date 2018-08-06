require 'solr/testing'

module Solr
  module Query
    class RequestRunner
      SOLR_SELECT_PATH = '/select'.freeze

      include Solr::ConnectionHelper

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
        Solr::Testing.set_last_solr_request_response(request_params, response)
        response
      end

      private

      def start
        start_page = @page.to_i - 1
        start_page = start_page < 1 ? 0 : start_page
        start_page * page_size
      end

      def connection
        Solr::Connection.new(SOLR_SELECT_PATH)
      end

      def request_params
        # https://lucene.apache.org/solr/guide/7_1/json-request-api.html#passing-parameters-via-json
        { params: solr_params.merge({ wt: :json, rows: page_size.to_i, start: start }) }
      end
    end
  end
end
