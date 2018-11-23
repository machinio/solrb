module Solr
  module Support
    module UrlHelper
      def self.solr_url(path, url_params: {})
        full_url = File.join(Solr.current_core_config.uri, path)
        full_uri = Addressable::URI.parse(full_url)
        full_uri.query_values = url_params if url_params.any?
        full_uri
      end

      def build_request_url(url:, collection_name:, path:, url_params: {})
        action_url = File.join(url, collection_name, path).chomp('/')
        full_uri = Addressable::URI.parse(action_url)
        full_uri.query_values = url_params if url_params.any?
        full_uri
      end
    end
  end
end
