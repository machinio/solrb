module Solr
  module ConnectionHelper
    def connection(path, commit: false)
      url_params = {}
      url_params[:commit] = true if commit
      url = Solr::UrlHelper.solr_url(path, url_params)
      Solr::Connection.new(url)
    end
  end
end