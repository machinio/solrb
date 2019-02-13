module Solr
  module Support
    module UrlHelper
      module_function

      def solr_url(path, url_params: {})
        full_url = File.join(core_url, path)
        full_uri = Addressable::URI.parse(full_url)
        full_uri.query_values = url_params if url_params.any?
        full_uri
      end

      def build_request_url(url:,path:, url_params: {})
        action_url = File.join(url, path).chomp('/')
        full_uri = Addressable::URI.parse(action_url)
        full_uri.query_values = url_params if url_params && url_params.any?
        full_uri
      end

      def core_url
        Solr.cloud_enabled? ? solr_cloud_url : current_core.uri
      end

      def solr_cloud_url
        File.join(Solr.active_nodes_for(collection: current_core.name.to_s).first, current_core.name.to_s)
      end

      def current_core
        Solr.current_core_config
      end
    end
  end
end
