require 'solr/query/response'
require 'solr/request/runner'
require 'solr/query/http_request_builder'

module Solr
  module Query
    class Handler
      attr_reader :query, :page, :page_size

      def initialize(query:, page:, page_size:)
        @query = query
        @page = page
        @page_size = page_size
      end

      def call
        http_request = Solr::Query::HttpRequestBuilder.call(query: query, page: page, page_size: page_size)
        solr_response = Solr::Request::Runner.call(request: http_request)
        Solr::Query::Response::Parser.new(request: query, solr_response: solr_response.body).to_response
      end
    end
  end
end
