module Solr
  module Commit
    class Request
      PATH = '/update'.freeze

      def run
        http_request = Solr::Request::HttpRequest.new(path: PATH, url_params: { commit: true }, method: :post)
        Solr::Request::Runner.call(request: http_request)
      end
    end
  end
end
