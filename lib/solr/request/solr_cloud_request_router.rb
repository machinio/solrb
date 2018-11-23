require 'solr/errors/cluster_connection_failed_error'
require 'solr/errors/no_active_solr_nodes_error'

module Solr
  module Request
    class SolrCloudRequestRouter
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
        raise Errors::NoActiveSolrNodesError unless active_solr_nodes_urls.any?

        # Based on Solrj V2Request implementation
        active_solr_nodes_urls.shuffle.each do |url|
          request_url = build_request_url(url: url,
                                          collection_name: active_collection_name,
                                          path: path,
                                          url_params: url_params)
          begin
            raw_response = Solr::Connection.new(request_url).public_send(method, request_params)
            response = Solr::Response.from_raw_response(raw_response)
            return response
          rescue Faraday::ConnectionFailed, Faraday::TimeoutError, Errno::EADDRNOTAVAIL => e
            # Try next node
          end
        end

        raise Errors::ClusterConnectionFailedError
      end

      private

      def active_solr_nodes_urls
        @active_solr_nodes_urls ||= Solr.cloud.active_nodes_for(collection: active_collection_name)
      end

      def active_collection_name
        Solr.current_core_config.name.to_s
      end
    end
  end
end
