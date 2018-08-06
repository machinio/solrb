require 'solr/field_configuration/dynamic_field'
require 'solr/field_configuration/field'
require 'solr/field_configuration/field_definition_builder'
require 'solr/errors/solr_url_not_defined_error'

module Solr
  class Configuration
    attr_accessor :faraday_options, :fields, :test_connection
    attr_writer :url

    def initialize
      @faraday_options = { request: { timeout: 2, open_timeout: 8 } }
      @url = ENV['SOLR_URL']
      @fields = {}
    end

    def uri
      @uri ||= Addressable::URI.parse(url)
    end

    def url
      raise Errors::SolrUrlNotDefinedError unless @url
      @url
    end

    def define_fields
      builder = Solr::FieldConfiguration::FieldDefinitionBuilder.new
      yield builder
      fields.merge!(builder.build)
    end
  end
end
