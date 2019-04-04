module Solr
  module Commit
    class Request
      PATH = '/update'.freeze

      def run(runner_options: nil)
        http_request = Solr::Request::HttpRequest.new(path: PATH, url_params: { commit: true, openSearcher: true }, method: :post)
        options = default_runner_options.merge(runner_options || {})
        Solr::Request::Runner.call(request: http_request, **options)
      end

      private

      def default_runner_options
        { node_selection_strategy: Solr::Request::LeaderNodeSelectionStrategy }
      end
    end
  end
end
