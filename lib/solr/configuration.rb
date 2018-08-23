require 'solr/core_configuration/dynamic_field'
require 'solr/core_configuration/field'
require 'solr/core_configuration/core_config'
require 'solr/core_configuration/core_config_builder'
require 'solr/errors/solr_url_not_defined_error'
require 'solr/errors/unspecified_core_error'

module Solr
  class Configuration
    attr_accessor :faraday_options, :cores, :test_connection

    def initialize
      @faraday_options = { request: { timeout: 2, open_timeout: 8 } }
      @core_to_uri_mapping = {}
      @core_to_url_mapping = {}
      @cores = {}
    end

    def uri(core: nil)
      @core_to_uri_mapping[core] ||= Addressable::URI.parse(url(core: core))
    end

    def url=(value)
      if value.nil?
        raise ArgumentError, "Solr's URL can't be nil"
      else
        @url = value
      end
    end

    def url(core: nil)
      return @core_to_url_mapping[core] if @core_to_url_mapping.has_key?(core)
      core_url = cores[core.to_sym]&.url if core
      core_url ||= @url
      core_url ||= default_core_config.url
      raise Errors::SolrUrlNotDefinedError unless core_url
      @core_to_url_mapping[core] = core_url
    end

    def default_core
      default_core_config.name
    end

    def default_core_config
      raise Errors::UnspecifiedCoreError if cores.count > 1
      cores.values.first || unspecified_core
    end

    def define_core(name: nil)
      builder = Solr::CoreConfiguration::CoreConfigBuilder.new(
        url: @url || unspecified_core.url,
        name: name
      )
      yield builder
      core = builder.build
      if cores.has_key?(core.name)
        raise "A core with name '#{core.name}' has been already defined"
      else
        cores[core.name] = core
      end
    end

    def unspecified_core
      Solr::CoreConfiguration::UnspecifiedCoreConfig.new
    end
  end
end
