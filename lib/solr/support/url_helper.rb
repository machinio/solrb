module Solr
  module Support
    module UrlHelper
      def self.solr_url(path, core: nil, url_params: {})
        full_url = File.join(Solr.configuration.uri(core: core), path)
        full_uri = Addressable::URI.parse(full_url)
        full_uri.query_values = url_params if url_params.any?
        full_uri
      end
    end
  end
end
