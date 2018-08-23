module Solr
  module Delete
    class Request
      include Solr::Support::ConnectionHelper
      using Solr::Support::HashExtensions

      PATH = '/update'.freeze

      attr_reader :core_name, :delete_command

      def initialize(options = {})
        options = validate_delete_options!(options)
        @core_name = options.delete(:core_name)
        @delete_command = { delete: options }
      end

      def run(commit: false)
        # need to think how to move out commit data from the connection, it doesn't belong there
        raw_response = connection(PATH, core_name: core_name, commit: commit).post_as_json(delete_command)
        Solr::Response.from_raw_response(raw_response)
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
