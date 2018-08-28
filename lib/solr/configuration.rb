require 'solr/core_configuration/dynamic_field'
require 'solr/core_configuration/field'
require 'solr/core_configuration/core_config'
require 'solr/core_configuration/core_config_builder'
require 'solr/errors/solr_url_not_defined_error'
require 'solr/errors/ambiguous_core_error'

module Solr
  class Configuration
    attr_accessor :faraday_options, :cores, :test_connection
    attr_reader :url

    def initialize
      @faraday_options = { request: { timeout: 2, open_timeout: 8 } }
      @cores = {}
    end

    def url=(value)
      if value.nil?
        raise ArgumentError, "Solr's URL can't be nil"
      else
        @url = value
      end
    end

    def core_config_by_name(core)
      cores[core.to_sym] || build_env_url_core_config(name: core)
    end

    def default_core_config
      defined_default_core_config = cores.values.detect(&:default?)
      return defined_default_core_config if defined_default_core_config
      raise Errors::AmbiguousCoreError if cores.count > 1
      cores.values.first || build_env_url_core_config
    end

    def define_core(name: nil, default: false)
      validate_default_core_config!(default: default)
      builder = Solr::CoreConfiguration::CoreConfigBuilder.new(
        name: name,
        default: default
      )
      yield builder
      core = builder.build
      if cores.has_key?(core.name)
        raise "A core with name '#{core.name}' has been already defined"
      else
        cores[core.name] = core
      end
    end

    def build_env_url_core_config(name: nil)
      Solr::CoreConfiguration::EnvUrlCoreConfig.new(name: name)
    end

    def validate_default_core_config!(default:)
      return unless default
      if cores.any? { |name, core_config| core_config.default? }
        raise ArgumentError, 'Only one default core can be specified'
      end
    end
  end
end
