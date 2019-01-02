require 'json'
require 'faraday'
require 'addressable/uri'
require 'solr/support'
require 'solr/version'
require 'solr/configuration'
require 'solr/connection'
require 'solr/document'
require 'solr/document_collection'
require 'solr/grouped_document_collection'
require 'solr/response'
require 'solr/request/runner'
require 'solr/query/request'
require 'solr/indexing/document'
require 'solr/indexing/request'
require 'solr/delete/request'
require 'solr/commit/request'
require 'solr/data_import/request'
require 'solr/cloud/configuration'
require 'solr/commands'

module Solr
  class << self
    include Solr::Commands

    CURRENT_CORE_CONFIG_VARIABLE_NAME = :solrb_current_core_config

    attr_accessor :configuration, :cloud

    Solr.configuration = Configuration.new

    def configure
      yield configuration
      configuration.validate!
      configuration
    end

    def current_core_config
      Thread.current[CURRENT_CORE_CONFIG_VARIABLE_NAME] || Solr.configuration.default_core_config
    end

    def with_core(core)
      core_config = Solr.configuration.core_config_by_name(core)
      old_core_config = Thread.current[CURRENT_CORE_CONFIG_VARIABLE_NAME]
      Thread.current[CURRENT_CORE_CONFIG_VARIABLE_NAME] = core_config
      yield
    ensure
      Thread.current[CURRENT_CORE_CONFIG_VARIABLE_NAME] = old_core_config
    end

    def solr_url(path = '')
      Solr::Support::UrlHelper.solr_url(path)
    end

    def instrument(name:, data: {})
      if defined? ActiveSupport::Notifications
        # Create a copy of data to avoid modifications on the original object by rails
        # https://github.com/rails/rails/blob/master/activesupport/lib/active_support/notifications.rb#L66-L70
        ActiveSupport::Notifications.instrument(name, data.dup) do
          yield if block_given?
        end
      else
        yield if block_given?
      end
    end

    def cloud_enabled?
      !cloud.nil?
    end

    def enable_solr_cloud
      raise 'You must provide a ZooKeeper URL to enable solr cloud mode' if configuration.zookeeper_url.nil?
      cloud = Solr::Cloud::Configuration.configure(zookeeper_url: configuration.zookeeper_url,
                                                   collections: configuration.cores.keys,
                                                   zookeeper_auth_user: configuration.zookeeper_auth_user,
                                                   zookeeper_auth_password: configuration.zookeeper_auth_password)
    end
  end
end
