require 'solr/request/http_request'

module Solr
  module Query
    class HttpRequestBuilder
      PATH = '/select'.freeze

      attr_reader :query, :start, :rows

      def self.call(opts)
        new(**opts).call
      end

      def initialize(query:, start:, rows:)
        @query = query
        @rows = rows
        @start = start
      end

      def call
        Solr::Request::HttpRequest.new(path: PATH,
                                       body: build_body,
                                       method: :post)
      end

      private

      # 🏋️
      def build_body
        @request_params ||= { params: solr_params.merge(wt: :json, rows: rows, start: start) }
      end

      def solr_params
        query.to_h
      end
    end
  end
end
