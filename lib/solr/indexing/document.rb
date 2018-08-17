module Solr
  module Indexing
    class Document
      include Solr::Support::SchemaHelper
      attr_reader :fields

      def initialize(fields = {})
        @fields = fields
      end

      def add_field(name, value)
        @fields[name] = value
      end

      # TODO: refactor & optimize this
      def as_json(core_name:)
        fields.map do |k, v|
          solr_field_name = solarize_field(core_name: core_name, field: k)
          [solr_field_name, v]
        end.to_h
      end
    end
  end
end
