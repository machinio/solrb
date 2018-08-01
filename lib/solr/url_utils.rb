module Solr
  module UrlUtils
    def solr_url(path)
      full_path = File.join(Solr.configuration.uri.path, path)
      URI.join(Solr.configuration.uri, full_path)
    end
  end
end