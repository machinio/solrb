require 'solr/request/default_solr_node_selector'

module Solr
  module Request
    class Runner
      include Solr::Support::UrlHelper

      attr_reader :request, :collection_name, :response_parser, :solr_node_selector

      def self.call(opts)
        new(opts).call
      end

      def initialize(request:,
                     collection_name:,
                     solr_node_selector: Solr::Request::DefaultSolrNodeSelector)
        @request = request
        @collection_name = collection_name
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
            response = Solr::Connection.call(url: request_url, method: request.method, body: request.body)
            return Solr::Response::Parser.call(response)
          rescue Faraday::ConnectionFailed, Faraday::TimeoutError, Errno::EADDRNOTAVAIL => e
            # Try next node
          end
        end

        raise Solr::Errors::ClusterConnectionFailedError
      end

      private

      def solr_nodes_urls
        @solr_nodes_urls ||= solr_node_selector.call(collection_name)
      end
    end
  end
end
