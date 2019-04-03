require 'solr/request/http_request'
require 'solr/request/leader_node_selection_strategy'

module Solr
  module Indexing
    class Request
      PATH = '/update'.freeze

      attr_reader :documents

      def initialize(documents = [])
        @documents = documents
      end

      def run(commit: false, options: {})
        http_request = build_http_request(commit)
        runner_options = { node_selection_strategy: Solr::Request::LeaderNodeSelectionStrategy }
        Solr::Request::Runner.call(request: http_request, **runner_options.merge(options))
      end

      private

      def build_http_request(commit)
        Solr::Request::HttpRequest.new(path: PATH, body: documents, url_params: { commit: commit }, method: :post)
      end
    end
  end
end
