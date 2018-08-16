require 'solr/core_configuration/dynamic_field'
require 'solr/core_configuration/field'
require 'solr/core_configuration/core_definition_builder'
require 'solr/errors/solr_url_not_defined_error'

module Solr
  class Configuration
    attr_accessor :faraday_options, :cores, :test_connection
    attr_writer :url

    def initialize
      @faraday_options = { request: { timeout: 2, open_timeout: 8 } }
      @url = ENV['SOLR_URL']
      @cores = {}
    end

    def uri
      @uri ||= Addressable::URI.parse(url)
    end

    def url
      raise Errors::SolrUrlNotDefinedError unless @url
      @url
    end

    def define_core(name:)
      builder = Solr::CoreConfiguration::CoreDefinitionBuilder.new(name: name)
      yield builder
      cores[name] = builder.build
    end
  end
end
