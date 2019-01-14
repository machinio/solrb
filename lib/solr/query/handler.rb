require 'solr/query/response'
require 'solr/request/runner'
require 'solr/query/http_request'

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
        http_request = Solr::Query::HttpRequest.new(query: query, page: page, page_size: page_size)
        solr_response = Solr::Request::Runner.call(request: http_request, collection_name: collection_name)
        raise Solr::Errors::SolrQueryError, solr_response.error_message unless solr_response.ok?
        Solr::Query::Response::Parser.new(request: query, solr_response: solr_response.body).to_response
      end

      def collection_name
        Solr.current_core_config.name
      end
    end
  end
end
