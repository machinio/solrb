module Solr
  module Request
    class DefaultSolrNodeSelector
      attr_reader :collection_name

      def self.call(collection_name)
        new(collection_name).call
      end

      def initialize(collection_name)
        @collection_name = collection_name
      end

      def call
        Solr.cloud_enabled? ? solr_cloud_active_nodes_urls.shuffle : [solr_url]
      end

      private

      def solr_cloud_active_nodes_urls
        Solr.cloud.active_nodes_for(collection: collection_name)
      end

      def solr_url
        Solr.configuration.url || base_url_from_env
      end

      def base_url_from_env
        url = ENV['SOLR_URL']
        return unless url
        uri = URI.parse(url)
        base_url = "#{uri.scheme}://#{uri.host}"
        base_url << ":#{uri.port}" if uri.port != 80
        base_url << "/solr"
        base_url
      end

      # def active_collection_name
      #   Solr.current_core_config.name.to_s
      # end
    end
  end
end
