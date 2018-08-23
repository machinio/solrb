module Solr
  module CoreConfiguration
    class CoreConfig
      attr_reader :name, :url, :fields

      def initialize(name:, url:, fields:)
        @name = name
        @url = url
        @fields = fields
        validate_options!
      end

      def field_by_name(field_name)
        fields[field_name.to_sym]
      end

      private

      def validate_options!
        raise ArgumentError, 'pass name or url' if name.nil? && url.nil?
      end
    end

    class UnspecifiedCoreConfig < CoreConfig
      attr_reader :name, :url, :fields

      def initialize(name: nil, url: ENV['SOLR_URL'], fields: {})
        @name = name
        @url = url
        @fields = fields
      end
    end
  end
end
