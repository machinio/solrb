module Solr
  module Indexing
    class Request
      COMMANDS_PATH = '/update/json'.freeze
      # DOCUMENTS_PATH = '/update/json/docs'.freeze

      attr_reader :commands

      def initialize(commands = [])
        @commands = commands
      end

      def run(commit: false, runner_options: nil)
        http_request = build_http_request(commit)
        options = default_runner_options.merge(runner_options || {})
        Solr::Request::Runner.call(request: http_request, **options)
      end

      private

      def default_runner_options
        if Solr.cloud_enabled?
          { node_selection_strategy: Solr::Request::Cloud::LeaderNodeSelectionStrategy }
        elsif Solr.master_slave_enabled?
          { node_selection_strategy: Solr::Request::MasterSlave::MasterNodeSelectionStrategy }
        else
          {}
        end
      end

      def build_http_request(commit)
        Solr::Request::HttpRequest.new(path: path, body: body, url_params: { commit: commit }, method: :post)
      end

      def path
        # body.is_a?(Array) ? DOCUMENTS_PATH : COMMANDS_PATH
        COMMANDS_PATH
      end
    end
  end
end
