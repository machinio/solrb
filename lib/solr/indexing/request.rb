module Solr
  module Indexing
    class Request
      PATH = '/update'.freeze

      attr_reader :documents

      def initialize(documents = [])
        @documents = documents
      end

      def run(commit: false, runner_options: nil)
        http_request = build_http_request(commit)
        options = default_runner_options.merge(runner_options || {})
        Solr::Request::Runner.call(request: http_request, **options)
      end

      private

      def default_runner_options
        { node_selection_strategy: Solr::Request::LeaderNodeSelectionStrategy }
      end

      def build_http_request(commit)
        Solr::Request::HttpRequest.new(path: PATH, body: documents, url_params: { commit: commit }, method: :post)
      end
    end
  end
end
