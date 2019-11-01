require 'solr/core_configuration/dynamic_field'
require 'solr/core_configuration/field'
require 'solr/core_configuration/core_config'
require 'solr/core_configuration/core_config_builder'
require 'solr/nodes_gray_list/configuration'
require 'solr/errors/solr_url_not_defined_error'
require 'solr/errors/ambiguous_core_error'
require 'solr/errors/could_not_infer_implicit_core_name'

module Solr
  class Configuration
    extend Forwardable

    delegate [:zookeeper_url, :zookeeper_url=, :zookeeper_auth_user=, :zookeeper_auth_password=] => :@cloud_configuration
    delegate [:master_url, :master_url=, :slave_url, :slave_url=, :disable_read_from_master,
      :disable_read_from_master=, :nodes_gray_list, :nodes_gray_list=] => :@master_slave_configuration

    SOLRB_USER_AGENT_HEADER = { user_agent: "Solrb v#{Solr::VERSION}" }.freeze

    attr_accessor :cores, :test_connection, :auth_user, :auth_password

    attr_reader :url, :faraday_options, :faraday_configuration, :cloud_configuration,
      :master_slave_configuration

    def initialize
      @faraday_options = {
        request: { timeout: 2, open_timeout: 8 },
        headers: SOLRB_USER_AGENT_HEADER
      }
      @faraday_configuration = nil
      @cores = {}
      @cloud_configuration = Solr::Cloud::Configuration.new
      @master_slave_configuration = Solr::MasterSlave::Configuration.new
    end

    def faraday_options=(options)
      options[:headers] ||= {}
      options[:headers].merge!(SOLRB_USER_AGENT_HEADER)
      @faraday_options = options
    end

    def faraday_configure(&block)
      @faraday_configuration = block
    end

    def url=(value)
      @url = value
    end

    def core_config_by_name(core)
      cores[core.to_sym] || build_env_url_core_config(name: core)
    end

    def default_core_config
      defined_default_core_config = cores.values.detect(&:default?)
      return defined_default_core_config if defined_default_core_config
      raise Solr::Errors::AmbiguousCoreError if cores.count > 1
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

    def core_name_from_solr_url_env
      full_solr_core_uri = URI.parse(ENV['SOLR_URL'])
      core_name = full_solr_core_uri.path.gsub('/solr', '').delete('/')

      if !core_name || core_name == ''
        raise Solr::Errors::CouldNotInferImplicitCoreName
      end

      core_name
    end

    def build_env_url_core_config(name: nil)
      name ||= core_name_from_solr_url_env
      Solr::CoreConfiguration::EnvUrlCoreConfig.new(name: name)
    end

    def validate_default_core_config!(default:)
      return unless default
      if cores.any? { |name, core_config| core_config.default? }
        raise ArgumentError, 'Only one default core can be specified'
      end
    end

    def validate!
      if !(url ||
           @cloud_configuration.zookeeper_url ||
           (@master_slave_configuration.master_url && @master_slave_configuration.slave_url) ||
           ENV['SOLR_URL'])
        raise Solr::Errors::SolrUrlNotDefinedError
      end
    end
  end
end
