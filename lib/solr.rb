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

    def delete_by_id(id, commit: false, core_name:)
      Solr::Delete::Request.new(core_name: core_name, id: id).run(commit: commit)
    end

    def delete_by_query(query, commit: false, core_name:)
      Solr::Delete::Request.new(core_name: core_name, query: query).run(commit: commit)
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
