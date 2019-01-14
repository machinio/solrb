require 'solr/request/http_request'

module Solr
  module Indexing
    class Request
      PATH = '/update'.freeze

      attr_reader :documents

      def initialize(documents = [])
        @documents = documents
      end

      def run(commit: false)
        http_request = build_http_request(commit)
        Solr::Request::Runner.call(request: http_request)
      end

      private

      def build_http_request(commit)
        Solr::Request::HttpRequest.new(path: PATH, body: documents.to_json, url_params: { commit: commit }, method: :post)
      end
    end
  end
end
