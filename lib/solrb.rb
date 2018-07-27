require 'solrb/version'
require 'solrb/utils'
require 'solrb/solr_caller'
require 'solrb/document_collection'
require 'solrb/grouped_document_collection'
require 'solrb/schema_helper'
require 'solrb/response/facet_value'
require 'solrb/response/field_facets'
require 'solrb/response/edismax_adapter'
require 'solrb/response/spellcheck'
require 'solrb/document'
require 'solrb/response'
require 'solrb/request'
require 'solrb/request/facet'
require 'solrb/request/limit_docs_by_field'
require 'solrb/request/filter'
require 'solrb/request/boost_magnitude'
require 'solrb/request/geo_filter'
require 'solrb/request/sorting'
require 'solrb/request/edismax_adapter'
require 'solrb/request/grouping'
require 'solrb/request/boosting'
require 'solrb/request/boosting/scale_function_boost'
require 'solrb/request/boosting/geodist_function'
require 'solrb/request/boosting/recent_field_value_boost_function'
require 'solrb/request/boosting/ranking_field_boost_function'
require 'solrb/request/boosting/field_value_match_boost_function'
require 'solrb/request/boosting/numeric_field_value_match_boost_function'
require 'solrb/request/boosting/textual_field_value_match_boost_function'
require 'solrb/request/boosting/dictionary_boost_function'
require 'solrb/request/boosting/exists_boost_function'
require 'solrb/request/boosting/field_value_less_than_boost_function'
require 'solrb/request/boosting/ln_function_boost'
require 'solrb/request/boosting/phrase_proximity_boost'
require 'solrb/request/spellcheck'
require 'solrb/request/sorting/field'
require 'solrb/request/field_with_boost'
require 'solrb/request/or_filter'

module Solrb
  class Configuration
    attr_accessor :filter_field_map, :solr_read_timeout, :solr_open_timeout, :solr_url

    def initialize
      @filter_field_map = {}
      @solr_read_timeout = 8
      @solr_open_timeout = 2
      @solr_url = ENV['SOLR_URL']
    end
  end

  class << self
    attr_accessor :configuration, :connection

    def configure
      self.configuration ||= Configuration.new
      yield configuration
      configuration.filter_field_map = configuration.filter_field_map.with_indifferent_access
    end

    def get_connection
      self.connection ||= begin
        opts = {
          url: configuration.solr_url,
          request: {
            params_encoder: Faraday::FlatParamsEncoder,
            timeout: configuration.solr_read_timeout,
            open_timeout: configuration.solr_open_timeout
          }
        }
        Faraday.new(opts)
      end
    end

    def with_instrumentation(name, params)
      if defined? ActiveSupport::Notifications
        ActiveSupport::Notifications.instrument(name, params) do
          yield
        end
      else
        yield
      end
    end
  end
end
