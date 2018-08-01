require 'json'
require 'uri'
require 'faraday'
require 'solr/configuration'
require 'solr/version'
require 'solr/connection'
require 'solr/utils'
require 'solr/document'
require 'solr/document_collection'
require 'solr/grouped_document_collection'
require 'solr/schema_helper'
require 'solr/request'
require 'solr/response'
require 'solr/indexing/document'
require 'solr/indexing/request'

module Solr
  class << self
    attr_accessor :configuration

    Solr.configuration = Configuration.new

    def configure
      yield configuration
    end
  end
end
