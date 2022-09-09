module Solr
  module Update
    module Commands
      class Add
        include Solr::Support::SchemaHelper

        COMMAND_KEY = 'add'.freeze

        attr_reader :doc, :options

        def initialize(doc: {}, **options)
          @doc = doc
          @options = options
        end

        def add_field(name, value)
          @doc[name] = value
        end

        # TODO: refactor & optimize this
        def to_json(_json_context)
          JSON.generate(
            options.merge({
              doc: solarized_doc
            })
          )
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
