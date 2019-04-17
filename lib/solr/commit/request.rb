module Solr
  module Commit
    class Request
      PATH = '/update'.freeze

      def run(open_searcher: true, optimize: false, runner_options: nil)
        http_request = build_http_request(open_searcher, optimize)
        options = default_runner_options.merge(runner_options || {})
        Solr::Request::Runner.call(request: http_request, **options)
      end

      private

      def default_runner_options
        { node_selection_strategy: Solr::Request::LeaderNodeSelectionStrategy }
      end

      def build_http_request(open_searcher, optimize)
        Solr::Request::HttpRequest.new(path: PATH,
                                       url_params: {
                                         commit: true,
                                         optimize: optimize,
                                         openSearcher: open_searcher
                                       },
                                       method: :post)
      end
    end
  end
end
