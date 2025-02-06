module Solr
  module CoreConfiguration
    class CoreConfig
      attr_reader :name, :fields

      def initialize(name:, fields:, default:)
        @name = name.nil? ? ENV['SOLR_CORE'] : name
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
        @url ||= begin
          url = Solr.configuration.url || ENV['SOLR_URL'] || ENV['SOLR_MASTER_URL']
          File.join(url, name.to_s).chomp('/')
        end
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
        raise ArgumentError, "SOLR_URL can't be nil" if ENV['SOLR_URL'].nil? && ENV['SOLR_MASTER_URL'].nil?

        url = ENV['SOLR_URL'] || ENV['SOLR_MASTER_URL']

        if ENV['SOLR_CORE'] && ENV['SOLR_CORE'] != ''
          File.join(*[url, name.to_s].compact)
        else
          url
        end
      end
    end
  end
end
