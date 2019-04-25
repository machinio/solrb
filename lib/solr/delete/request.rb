module Solr
  module Delete
    class Request
      using Solr::Support::HashExtensions

      PATH = '/update'.freeze

      attr_reader :delete_command

      def initialize(options = {})
        options = validate_delete_options!(options)
        @delete_command = { delete: options }
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
        Solr::Request::HttpRequest.new(path: PATH,
                                       body: delete_command,
                                       url_params: { commit: commit },
                                       method: :post)
      end

      def validate_delete_options!(options)
        options = options.deep_symbolize_keys
        id, query = options.values_at(:id, :query)
        error_message = 'options must contain either id or query, but not both'
        raise ArgumentError, error_message if id.nil? && query.nil?
        raise ArgumentError, error_message if id && query
        options
      end
    end
  end
end
