module Solr
  module UrlHelper
    def self.solr_url(path, params = {})
      full_path = File.join(Solr.configuration.uri.path, path)
      full_uri = Addressable::URI.join(Solr.configuration.uri, full_path)
      full_uri.query_values = params if params.any?
      full_uri
    end
  end
end
