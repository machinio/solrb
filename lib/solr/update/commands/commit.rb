module Solr
  module Update
    module Commands
      class Commit
        COMMAND_KEY = 'commit'.freeze

        def self.unnest(array)
          array.first
        end

        attr_reader :options

        def initialize(options = {})
          @options = options
        end

        def as_json
          options
        end

        def to_json(_json_context)
          JSON.generate(as_json)
        end
      end
    end
  end
end
