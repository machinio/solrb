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
require 'solr/query/request'
require 'solr/response'
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

    def delete_by_id(_id, commit: false)
      # TODO: Hardcoded id??
      Solr::Delete::Request.new(id: 1).run(commit: commit)
    end

    def delete_by_query(query, commit: false)
      Solr::Delete::Request.new(query: query).run(commit: commit)
    end
  end
end
