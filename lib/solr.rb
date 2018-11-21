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
require 'solr/query/request'
require 'solr/indexing/document'
require 'solr/indexing/request'
require 'solr/delete/request'
require 'solr/commit/request'
require 'solr/cloud/configuration'

module Solr
  class << self
    CURRENT_CORE_CONFIG_VARIABLE_NAME = :solrb_current_core_config

    attr_accessor :configuration, :cloud

    Solr.configuration = Configuration.new

    def configure
      yield configuration
    end

    def current_core_config
      Thread.current[CURRENT_CORE_CONFIG_VARIABLE_NAME] || Solr.configuration.default_core_config
    end

    def commit
      Solr::Commit::Request.new.run
    end

    def delete_by_id(id, commit: false)
      Solr::Delete::Request.new(id: id).run(commit: commit)
    end

    def delete_by_query(query, commit: false)
      Solr::Delete::Request.new(query: query).run(commit: commit)
    end

    def with_core(core)
      core_config = Solr.configuration.core_config_by_name(core)
      old_core_config = Thread.current[CURRENT_CORE_CONFIG_VARIABLE_NAME]
      Thread.current[CURRENT_CORE_CONFIG_VARIABLE_NAME] = core_config
      yield
    ensure
      Thread.current[CURRENT_CORE_CONFIG_VARIABLE_NAME] = old_core_config
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
      !@cloud.nil?
    end

    def enable_solr_cloud
      raise 'You must provide a ZooKeeper URL to enable solr cloud mode' if configuration.zookeeper_url.nil?
      @cloud = Solr::Cloud::Configuration.configure(configuration.zookeeper_url, configuration.cores.keys)
    end
  end
end
