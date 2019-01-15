require 'solr/request/default_node_selection_strategy'
require 'solr/errors/solr_query_error'
require 'solr/errors/solr_connection_failed_error'

module Solr
  module Request
    # TODO: Add documentation about request running
    class Runner
      include Solr::Support::UrlHelper

      attr_reader :request, :response_parser, :node_selection_strategy

      def self.call(opts)
        new(opts).call
      end

      def initialize(request:,
                     node_selection_strategy: Solr::Request::DefaultNodeSelectionStrategy)
        @request = request
        @response_parser = response_parser
        @node_selection_strategy = node_selection_strategy
      end

      def call
        solr_urls.each do |node_url|
          request_url = build_request_url(url: node_url,
                                          path: request.path,
                                          url_params: request.url_params)
          begin
            raw_response = Solr::Connection.call(url: request_url, method: request.method, body: request.body)
            solr_response = Solr::Response::Parser.call(raw_response)
            raise Solr::Errors::SolrQueryError, solr_response.error_message unless solr_response.ok?
            return solr_response
          rescue Faraday::ConnectionFailed, Faraday::TimeoutError, Errno::EADDRNOTAVAIL => e
            # Try next node
          end
        end

        raise Solr::Errors::SolrConnectionFailedError.new(solr_urls)
      end

      private

      def solr_urls
        @solr_urls ||= begin
          urls = Solr.cloud_enabled? ? solr_cloud_collection_urls : [Solr.current_core_config.url]
          unless urls && urls.any?
            raise Solr::Errors::NoActiveSolrNodesError
          end
          urls
        end
      end

      def solr_cloud_collection_urls
        urls = node_selection_strategy.call(collection_name)
        return unless urls
        urls.map do |url|
          File.join(url, collection_name.to_s)
        end
      end

      def collection_name
        Solr.current_core_config.name
      end
    end
  end
end
