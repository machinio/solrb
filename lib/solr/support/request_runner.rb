module Solr
  module Support
    class RequestRunner
      class << self
        def post_as_json(path, request_params, url_params = {})
          new(path, request_params, url_params).post_as_json
        end
      end

      attr_reader :path, :request_params, :url_params

      def initialize(path, request_params, url_params = {})
        @path = path
        @request_params = request_params
        @url_params = url_params
      end

      def post_as_json
        raise Errors::NoActiveSolrNodesError unless available_nodes_urls.any?

        available_nodes_urls.shuffle.each do |url|
          request_url = build_request_url(url, path, url_params)
          begin
            raw_response = Solr::Connection.new(request_url).post_as_json(request_params)
            response = Solr::Response.from_raw_response(raw_response)
            return response
          rescue Faraday::ClientError => e
            # Try next node
          end
        end

        raise Errors::ClusterConnectionFailedError
      end

      private

      def available_nodes_urls
        @available_nodes_urls ||= if Solr.cloud_enabled?
          Solr.cloud.active_nodes_for(collection: active_core_name).map do |url|
            build_collection_url(url, active_core_name)
          end
        else
          [core_url]
        end
      end

      def core_url
        File.join(Solr.configuration.url || ENV['SOLR_URL'], active_core_name).chomp('/')
      end

      def active_core_name
        Solr.current_core_config.name.to_s
      end

      def build_collection_url(base_url, collection_name)
        File.join(base_url, collection_name).chomp('/')
      end

      def build_request_url(url, path, url_params = {})
        action_url = File.join(url, path).chomp('/')
        full_uri = Addressable::URI.parse(action_url)
        full_uri.query_values = url_params if url_params.any?
        full_uri
      end
    end
  end
end
