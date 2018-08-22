require 'solr/core_configuration/dynamic_field'
require 'solr/core_configuration/field'
require 'solr/core_configuration/core'
require 'solr/core_configuration/core_definition_builder'
require 'solr/errors/solr_url_not_defined_error'
require 'solr/errors/multiple_solr_cores_error'

module Solr
  class Configuration
    attr_accessor :faraday_options, :cores, :test_connection

    def initialize
      @faraday_options = { request: { timeout: 2, open_timeout: 8 } }
      @cores = {}
    end

    def uri(core_name: nil)
      Addressable::URI.parse(url(core_name: core_name))
    end

    def url=(value)
      if value.nil?
        raise Errors::SolrUrlNotDefinedError
      else
        @url = value
      end
    end

    def url(core_name: nil)
      core_url = cores[core_name.to_sym]&.url if core_name
      core_url ||= @url
      core_url ||= default_core.url
      raise Errors::SolrUrlNotDefinedError unless core_url
      core_url
    end

    def default_core_name
      default_core.name
    end

    def default_core
      raise Errors::MultipleSolrCoresError if cores.count > 1
      cores.values.first || null_core
    end

    def define_core(name: nil)
      builder = Solr::CoreConfiguration::CoreDefinitionBuilder.new(
        url: @url || null_core.url,
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

    def null_core
      Solr::CoreConfiguration::NullCore.new
    end
  end
end
