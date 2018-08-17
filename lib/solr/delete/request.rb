module Solr
  module Delete
    class Request
      include Solr::Support::ConnectionHelper
      using Solr::Support::HashExtensions

      SOLR_DELETE_PATH = 'update'.freeze

      attr_reader :core_name, :delete_command

      def initialize(options = {})
        options = validate_delete_options!(options)
        @core_name = options.delete(:core_name)
        @delete_command = { delete: options }
      end

      def run(commit: false)
        # need to think how to move out commit data from the connection, it doesn't belong there
        raw_response = connection(path, commit: commit).post_as_json(delete_command)
        # binding.irb
        Solr::Response.from_raw_response(raw_response)
      end

      private

      def validate_delete_options!(options)
        options = options.deep_symbolize_keys
        core_name, id, query = options.values_at(:core_name, :id, :query)
        error_message = 'options must contain either id or query, but not both'
        raise ArgumentError, error_message if id.nil? && query.nil?
        raise ArgumentError, error_message if id && query
        options
      end

      def path
        File.join('/', core_name.to_s, SOLR_DELETE_PATH)
      end
    end
  end
end
