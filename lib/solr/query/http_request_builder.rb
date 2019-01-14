require 'solr/request/http_request'

module Solr
  module Query
    class HttpRequestBuilder
      PATH = '/select'.freeze

      attr_reader :query, :page, :page_size

      def self.call(opts)
        new(opts).call
      end

      def initialize(query:, page:, page_size:)
        @query = query
        @page = page
        @page_size = page_size
      end

      def call
        Solr::Request::HttpRequest.new(path: PATH,
                                       body: build_body,
                                       method: :post)
      end

      private

      # 🏋️
      def build_body
        @request_params ||= { params: solr_params.merge(wt: :json, rows: page_size.to_i, start: start) }
      end

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
