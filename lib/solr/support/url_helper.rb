module Solr
  module Support
    module UrlHelper
      def self.solr_url(path, core_name: nil, url_params: {})
        full_url = File.join(Solr.configuration.uri(core_name: core_name), path)
        full_uri = Addressable::URI.parse(full_url)
        full_uri.query_values = url_params if url_params.any?
        full_uri
      end
    end
  end
end
