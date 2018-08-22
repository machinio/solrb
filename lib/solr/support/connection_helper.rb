module Solr
  module Support
    module ConnectionHelper
      def connection(path, core_name: nil, commit: false)
        url_params = {}
        url_params[:commit] = true if commit
        url = Solr::Support::UrlHelper.solr_url(path, core_name: core_name, url_params: url_params)
        Solr::Connection.new(url)
      end
    end
  end
end
