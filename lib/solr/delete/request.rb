module Solr
  module Delete
    class Request
      include Solr::Support::ConnectionHelper
      using Solr::Support::HashExtensions

      PATH = '/update'.freeze

      attr_reader :delete_command

      def initialize(options = {})
        options = validate_delete_options!(options)
        @delete_command = { delete: options }
      end

      def run(commit: false)
        Solr::Support::RequestRunner.post_as_json(PATH, delete_command, commit: commit)
      end

      private

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
