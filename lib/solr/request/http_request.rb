module Solr
  module Request
    class HttpRequest
      attr_reader :path, :body, :url_params, :method

      def initialize(path: '/', body: {}, url_params: {}, method: :get)
        @path = path
        @body = body
        @url_params = url_params
        @method = method
      end
    end
  end
end
