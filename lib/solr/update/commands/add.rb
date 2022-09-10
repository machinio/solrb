module Solr
  module Update
    module Commands
      class Add
        include Solr::Support::SchemaHelper

        COMMAND_KEY = 'add'.freeze

        attr_reader :doc

        def self.unnest(array)
          array
        end

        def initialize(doc: {})
          @doc = doc
        end

        def add_field(name, value)
          @doc[name] = value
        end

        # TODO: refactor & optimize this
        def as_json
          solarized_doc
        end

        def to_json(_json_context)
          JSON.generate(as_json)
        end

        private

        def solarized_doc
          doc.map do |k, v|
            solr_field_name = solarize_field(k)
            [solr_field_name, v]
          end.to_h
        end
      end
    end
  end
end
