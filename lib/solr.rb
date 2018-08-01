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
    attr_accessor :field_map_function, :solr_read_timeout, :solr_open_timeout, :solr_url

    def initialize
      @solr_read_timeout = 8
      @solr_open_timeout = 2
      @solr_url = ENV['SOLR_URL']
      @field_map_function = -> (field) { field }
    end
  end

  class << self
    attr_accessor :configuration, :connection

    def configure
      self.configuration ||= Configuration.new
      yield configuration
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
