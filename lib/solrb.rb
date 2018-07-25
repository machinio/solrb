require 'solrb/version'
require 'solrb/schema'
require 'solrb/document_collection'
require 'solrb/grouped_document_collection'
require 'solrb/schema_helper'
require 'solrb/response/facet_value'
require 'solrb/response/field_facets'
require 'solrb/response/rsolr_adapter'
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
require 'solrb/request/rsolr_adapter'
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
    attr_accessor :filter_field_map

    def initialize
      @filter_field_map = {}
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield configuration
  end
end
