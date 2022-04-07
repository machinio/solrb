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

      def build_request_url(url:, path:, url_params: {})
        action_url = File.join(url, path).chomp('/')
        full_uri = Addressable::URI.parse(action_url)
        full_uri.query_values = url_params if url_params && url_params.any?
        full_uri
      end

      def core_url
        if Solr.cloud_enabled? || Solr.master_slave_enabled?
          solr_cloud_or_master_slave_url
        else
          current_core.uri
        end
      end

      def solr_cloud_or_master_slave_url
        url = Solr.active_nodes_for(collection: current_core.name.to_s).first
        File.join(url, current_core.name.to_s)
      end

      def current_core
        Solr.current_core_config
      end

      def core_name_from_url(url)
        full_solr_core_uri = URI.parse(url)
        core_name = full_solr_core_uri.path.gsub('/solr', '').delete('/')

        if !core_name || core_name == ''
          raise Solr::Errors::CouldNotInferImplicitCoreName
        end

        core_name
      end

      def solr_endpoint_from_url(url)
        solr_endpoint = url[/(\A.+\/solr)/]

        if !solr_endpoint || solr_endpoint == ''
          raise Solr::Errors::CouldNotDetectEndpointInUrl
        end

        solr_endpoint
      end
    end
  end
end
