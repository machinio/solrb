module Solr
  module Indexing
    class Document
      include Solr::SchemaHelper
      attr_reader :fields

      def initialize(fields = {})
        @fields = fields
      end

      def add_field(name, value)
        @fields[name] = value
      end

      # TODO: refactor & optimize this
      def to_json(_json_context)
        solr_fields = fields.map do |k, v|
          solr_field_name = solarize_field(k)
          [solr_field_name, v]
        end.to_h
        JSON.generate(solr_fields)
      end
    end
  end
end
