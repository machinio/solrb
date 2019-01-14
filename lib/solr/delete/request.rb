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

      def run(commit: false)
        http_request = build_http_request(commit)
        Solr::Request::Runner.call(request: http_request)
      end

      private

      def build_http_request(commit)
        Solr::Request::HttpRequest.new(path: PATH, body: delete_command, url_params: { commit: commit }, method: :post)
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
