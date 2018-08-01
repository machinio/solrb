module Solr
  module UrlUtils
    def solr_url(path, params = {})
      full_path = File.join(Solr.configuration.uri.path, path)
      full_uri = Addressable::URI.join(Solr.configuration.uri, full_path)
      if params.any?
        full_uri.query_values = params
      end
      full_uri
    end
  end
end