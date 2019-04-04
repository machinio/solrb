module Solr
  module DataImport
    class Request
      PATH = '/dataimport'.freeze

      attr_reader :params

      def initialize(params)
        @params = params
      end

      # We want to make sure we send every dataimport request to the same node because this same class
      # could be used to start a dataimport and to get dataimport progress data afterwards.
      # To make it consistent we will send dataimport requests only to the first shard leader replica
      def run(runner_options: nil)
        http_request = Solr::Request::HttpRequest.new(path: PATH, url_params: params, method: :get)
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
