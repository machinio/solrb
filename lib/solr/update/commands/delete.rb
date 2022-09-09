module Solr
  module Update
    module Commands
      class Delete
        using Solr::Support::HashExtensions

        COMMAND_KEY = 'delete'.freeze

        attr_reader :options

        def initialize(options = {})
          options = validate_delete_options!(options)
          @options = options
        end

        def to_json(_json_context)
          JSON.generate(options)
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
end
