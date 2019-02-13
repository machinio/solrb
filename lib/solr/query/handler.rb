require 'solr/query/response'
require 'solr/request/runner'
require 'solr/query/http_request_builder'

module Solr
  module Query
    class Handler
      attr_reader :query, :rows, :start

      def self.call(opts)
        new(opts).call
      end

      def initialize(query:, rows:, start:)
        @query = query
        @rows = rows
        @start = start
      end

      def call
        http_request = Solr::Query::HttpRequestBuilder.call(query: query, start: start, rows: rows)
        solr_response = Solr::Request::Runner.call(request: http_request)
        Solr::Query::Response::Parser.new(request: query, solr_response: solr_response.body).to_response
      end
    end
  end
end
