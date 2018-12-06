require 'solr/errors/cluster_connection_failed_error'
require 'solr/errors/no_active_solr_nodes_error'

module Solr
  module Request
    class SolrCloudLeaderRouter
      include Solr::Support::UrlHelper

      attr_reader :path, :url_params, :request_params, :method

      def self.run(opts)
        new(opts).run
      end

      def initialize(path:, url_params: {}, request_params: {}, method: :post)
        @path = path
        @url_params = url_params
        @request_params = request_params
        @method = method
      end

      def run
        puts collection_leader_solr_node
        raise Solr::Errors::NoActiveSolrNodesError unless collection_leader_solr_node

        request_url = build_request_url(url: collection_leader_solr_node,
                                        collection_name: active_collection_name,
                                        path: path,
                                        url_params: url_params)
        raw_response = Solr::Connection.new(request_url).public_send(method, request_params)
        Solr::Response.from_raw_response(raw_response)
      end

      private

      def collection_leader_solr_node
        @collection_leader_solr_node ||= Solr.cloud.leader_node_for(collection: active_collection_name)
      end

      def active_collection_name
        Solr.current_core_config.name.to_s
      end
    end
  end
end
