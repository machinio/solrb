require 'solr/query/request/boosting/scale_function_boost'
require 'solr/query/request/boosting/geodist_function'
require 'solr/query/request/boosting/recent_field_value_boost_function'
require 'solr/query/request/boosting/ranking_field_boost_function'
require 'solr/query/request/boosting/field_value_match_boost_function'
require 'solr/query/request/boosting/numeric_field_value_match_boost_function'
require 'solr/query/request/boosting/textual_field_value_match_boost_function'
require 'solr/query/request/boosting/dictionary_boost_function'
require 'solr/query/request/boosting/exists_boost_function'
require 'solr/query/request/boosting/field_value_less_than_boost_function'
require 'solr/query/request/boosting/ln_function_boost'
require 'solr/query/request/boosting/phrase_proximity_boost'

module Solr
  module Query
    class Request
      class Boosting
        class << self
          def empty
            @empty ||= new
          end
        end

        attr_reader :additive_boost_functions, :multiplicative_boost_functions, :phrase_boosts, :spatial_boost

        def initialize(additive_boost_functions: [], multiplicative_boost_functions: [], phrase_boosts: [])
          @additive_boost_functions = additive_boost_functions
          @multiplicative_boost_functions = multiplicative_boost_functions
          @phrase_boosts = phrase_boosts
          @spatial_boost = find_spatial_boost
          freeze
        end

        def empty?
          [multiplicative_boost_functions, additive_boost_functions, phrase_boosts].all(&:empty?)
        end

        private

        def find_spatial_boost
          multiplicative_boost_functions.find { |mbf| mbf.is_a? ::Solr::Query::Request::Boosting::GeodistFunction }
        end
      end
    end
  end
end
