require 'json'
require 'faraday'
require 'addressable/uri'
require 'solr/support'
require 'solr/configuration'
require 'solr/version'
require 'solr/connection'
require 'solr/document'
require 'solr/document_collection'
require 'solr/grouped_document_collection'
require 'solr/response'
require 'solr/query/request'
require 'solr/indexing/document'
require 'solr/indexing/request'
require 'solr/delete/request'

module Solr
  class << self
    attr_accessor :configuration

    Solr.configuration = Configuration.new

    def configure
      yield configuration
    end

    def current_core_config
      Thread.current[:solrb_current_core_config] || Solr.configuration.default_core_config
    end

    def delete_by_id(id, commit: false)
      Solr::Delete::Request.new(id: id).run(commit: commit)
    end

    def delete_by_query(query, commit: false)
      Solr::Delete::Request.new(query: query).run(commit: commit)
    end

    def with_core(core)
      core_config = Solr.configuration.core_config_by_name(core)
      old_core_config = Thread.current[:solrb_current_core_config]
      Thread.current[:solrb_current_core_config] = core_config
      yield
    ensure
      Thread.current[:solrb_current_core_config] = old_core_config
    end

    def instrument(name:, data: {})
      if defined? ActiveSupport::Notifications
        ActiveSupport::Notifications.instrument(name, data) do
          yield if block_given?
        end
      else
        yield if block_given?
      end
    end
  end
end
