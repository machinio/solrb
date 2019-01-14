require 'solr/request/base_http_request'

module Solr
  module Query
    class HttpRequest < Solr::Request::BaseHttpRequest
      PATH = '/select'.freeze

      attr_reader :query, :page, :page_size

      def initialize(query:, page:, page_size:)
        @query = query
        @page = page
        @page_size = page_size
      end

      def body
        # https://lucene.apache.org/solr/guide/7_1/json-request-api.html#passing-parameters-via-json
        @request_params ||= { params: solr_params.merge(wt: :json, rows: page_size.to_i, start: start) }
      end

      def path
        PATH
      end

      def method
        :post
      end

      private

      def start
        start_page = page.to_i - 1
        start_page = start_page < 1 ? 0 : start_page
        start_page * page_size
      end

      def solr_params
        query.to_h
      end
    end
  end
end
