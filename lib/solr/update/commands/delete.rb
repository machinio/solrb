module Solr
  module Update
    module Commands
      class Delete
        using Solr::Support::HashExtensions

        COMMAND_KEY = 'delete'.freeze

        def self.unnest(array)
          array.first
        end

        attr_reader :options

        def initialize(options = {})
          options = validate_delete_options!(options)
          @options = options
        end

        def as_json
          if options.key?(:filters)
            { query: options[:filters].map(&:to_solr_s).join(' AND ') }
          else
            options
          end
        end

        def to_json(_json_context)
          JSON.generate(as_json)
        end

        private

        def validate_delete_options!(options)
          options = options.deep_symbolize_keys
          id, query, filters = options.values_at(:id, :query, :filters)
          error_message = 'options must contain either id, query or filters'
          raise ArgumentError, error_message if [id, query, filters].compact.count != 1
          options
        end
      end
    end
  end
end
