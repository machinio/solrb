require 'solr/request/node_selection_strategy'
require 'solr/request/default_node_selection_strategy'
require 'solr/request/cloud/first_shard_leader_node_selection_strategy'
require 'solr/request/cloud/leader_node_selection_strategy'
require 'solr/request/master_slave/master_node_selection_strategy'
require 'solr/errors/solr_query_error'
require 'solr/errors/solr_connection_failed_error'
require 'solr/errors/no_active_solr_nodes_error'

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
                     node_selection_strategy: Solr::Request::DefaultNodeSelectionStrategy,
                     solr_connection: Solr::Connection)
        @request = request
        @response_parser = response_parser
        @node_selection_strategy = node_selection_strategy
        @solr_connection = solr_connection
      end

      def call
        solr_url_errors = {}
        solr_urls.each do |node_url|
          request_url = build_request_url(url: node_url,
                                          path: request.path,
                                          url_params: request.url_params)
          begin
            raw_response = @solr_connection.call(url: request_url.to_s, method: request.method, body: request.body)
            solr_response = Solr::Response::Parser.call(raw_response)
            raise Solr::Errors::SolrQueryError, solr_response.error_message unless solr_response.ok?
            return solr_response
          rescue Faraday::ConnectionFailed, Faraday::TimeoutError, Errno::EADDRNOTAVAIL => e
            solr_url_errors[node_url] = "#{e.class.name} - #{e.message}"
            # Try next node
          end
        end

        raise Solr::Errors::SolrConnectionFailedError.new(solr_url_errors)
      end

      private

      def solr_urls
        @solr_urls ||= begin
          urls = if Solr.cloud_enabled? || Solr.master_slave_enabled?
            solr_collection_urls
          else
            [Solr.current_core_config.url]
          end
          unless urls && urls.any?
            raise Solr::Errors::NoActiveSolrNodesError
          end
          urls
        end
      end

      def solr_collection_urls
        urls = node_selection_strategy.call(collection_name)
        urls&.map { |u| File.join(u, collection_name.to_s) }
      end

      def collection_name
        Solr.current_core_config.name
      end
    end
  end
end
