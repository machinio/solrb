require 'solr/request/default_solr_node_selector'

module Solr
  module Request
    # TODO: Add documentation about request running
    class Runner
      include Solr::Support::UrlHelper

      attr_reader :request, :response_parser, :solr_node_selector

      def self.call(opts)
        new(opts).call
      end

      def initialize(request:,
                     node_selection_strategy: Solr::Request::DefaultNodeSelectionStrategy)
        @request = request
        @response_parser = response_parser
        @solr_node_selector = solr_node_selector
      end

      def call
        unless solr_nodes_urls && solr_nodes_urls.any?
          raise Solr::Errors::NoActiveSolrNodesError
        end

        solr_nodes_urls.each do |node_url|
          request_url = build_request_url(url: node_url,
                                          collection_name: collection_name,
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

        raise Solr::Errors::ClusterConnectionFailedError
      end

      private

      def solr_nodes_urls
        @solr_nodes_urls ||= node_selection_strategy.call(collection_name)
      end

      def collection_name
        Solr.current_core_config.name
      end
    end
  end
end
