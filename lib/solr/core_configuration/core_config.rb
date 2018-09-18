module Solr
  module CoreConfiguration
    class CoreConfig
      attr_reader :name, :fields

      def initialize(name:, fields:, default:)
        @name = name
        @fields = fields
        @default = default
      end

      def field_by_name(field_name)
        fields[field_name.to_sym]
      end

      def default?
        @default
      end

      def url
        @url ||= File.join(Solr.configuration.url || ENV['SOLR_URL'], name.to_s).chomp('/')
      end

      def uri
        @uri ||= Addressable::URI.parse(url)
      end
    end

    class EnvUrlCoreConfig < CoreConfig
      attr_reader :name, :fields

      def initialize(name: nil, fields: {})
        @name = name
        @fields = fields
        @default = false
      end

      def url
        raise ArgumentError, "Solr URL can't be nil" if ENV['SOLR_URL'].nil?
        ENV['SOLR_URL']
      end
    end
  end
end
