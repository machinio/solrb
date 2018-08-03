require 'solr/field_configuration/field'
require 'solr/field_configuration/dynamic_field'
require 'solr/field_configuration/dynamic_field_definition_builder'
require 'solr/field_configuration/dynamic_field_mapper'


module Solr
  class Configuration
    NO_URL_ERROR_MESSAGE = '
    Solrb gem requires you to set the URL of your Solr instance
    either through SOLR_URL environmental variable or explicitly inside the configure block:

    Solr.configure do |config|
      config.url = "http://localhost:8983/solr/core"
    end
    '.freeze

    attr_accessor :faraday_options, :field_types, :fields, :test_connection
    attr_writer :url

    def initialize
      @faraday_options = { request: { timeout: 2, open_timeout: 8 } }
      @url = ENV['SOLR_URL']
      @field_types = {}
      @fields = {}
    end

    def uri
      @uri ||= URI.parse(url)
    end

    def url
      raise NO_URL_ERROR_MESSAGE unless @url
      @url
    end

    def define_dynamic_fields
      builder = Solr::FieldConfiguration::DynamicFieldDefinitionBuilder.new
      yield builder
      field_types.merge!(builder.build)
    end

    def map_dynamic_fields
      builder = Solr::FieldConfiguration::DynamicFieldMapper.new(field_types)
      yield builder
      fields.merge!(builder.build)
    end
  end
end
