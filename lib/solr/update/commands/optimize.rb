module Solr
  module Update
    module Commands
      class Optimize
        COMMAND_KEY = 'optimize'.freeze

        def self.unnest(array)
          array.first
        end

        attr_reader :options

        def initialize(options = {})
          @options = options
        end

        def to_json(_json_context)
          JSON.generate(options)
        end
      end
    end
  end
end
