module Solr
  module Indexing
    class Document
      def initialize
        @fields = {}
      end

      def add_field(name, value)
        @fields[name] = value
      end

      # TODO: refactor & optimize this
      def to_json(_json_context)
        solr_fields = @fields.map do |k, v|
          solr_field_name = Solr.configuration.field_map.fetch(k, k)
          [solr_field_name, v]
        end.to_h
        JSON.generate(solr_fields)
      end
    end
  end
end