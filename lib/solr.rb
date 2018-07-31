require 'solr/version'
require 'solr/utils'
require 'solr/solr_caller'
require 'solr/document'
require 'solr/document_collection'
require 'solr/grouped_document_collection'
require 'solr/schema_helper'
require 'solr/request'
require 'solr/response'

module Solr
  class Configuration
    attr_accessor :filter_field_map, :solr_read_timeout, :solr_open_timeout, :solr_url

    def initialize
      @filter_field_map = {}
      @solr_read_timeout = 8
      @solr_open_timeout = 2
      @solr_url = ENV['SOLR_URL']
    end
  end

  class << self
    attr_accessor :configuration, :connection

    def configure
      self.configuration ||= Configuration.new
      yield configuration
      configuration.filter_field_map = configuration.filter_field_map.with_indifferent_access
    end

    def get_connection
      self.connection ||= begin
        opts = {
          url: configuration.solr_url,
          request: {
            params_encoder: Faraday::FlatParamsEncoder,
            timeout: configuration.solr_read_timeout,
            open_timeout: configuration.solr_open_timeout
          }
        }
        Faraday.new(opts)
      end
    end

    def with_instrumentation(name, params)
      if defined? ActiveSupport::Notifications
        ActiveSupport::Notifications.instrument(name, params) do
          yield
        end
      else
        yield
      end
    end
  end
end
