require 'solr/query/request/facet'
require 'solr/query/request/filter'
require 'solr/query/request/boost_magnitude'
require 'solr/query/request/geo_filter'
require 'solr/query/request/sorting'
require 'solr/query/request/edismax_adapter'
require 'solr/query/request/grouping'
require 'solr/query/request/boosting'
require 'solr/query/request/spellcheck'
require 'solr/query/request/field_list'
require 'solr/query/request/sorting/field'
require 'solr/query/request/sorting/function'
require 'solr/query/request/query_field'
require 'solr/query/request/or_filter'
require 'solr/query/request/and_filter'
require 'solr/query/request/shards_preference'
require 'solr/query/handler'

module Solr
  module Query
    class Request
      attr_reader :search_term
      attr_accessor :filters, :query_fields, :field_list, :facets, :boosting, :debug_mode, :spellcheck,
                    :limit_docs_by_field, :phrase_slop, :query_operator
      attr_writer :grouping, :sorting, :shards_preference

      def initialize(search_term:, query_fields: [], field_list: Solr::Query::Request::FieldList.new, filters: [])
        @search_term = search_term
        @query_fields = query_fields
        @field_list = field_list
        @filters = filters
      end

      def run(page: nil, start: nil, rows: nil, page_size: nil, runner_options: {})
        rows ||= page_size
        return run_paged(page: page, page_size: rows, runner_options: runner_options) if page && rows
        return run_start(start: start, rows: rows, runner_options: runner_options) if start && rows
        raise ArgumentError, 'You must specify either page/rows or start/rows arguments'
      end

      def grouping
        @grouping ||= Solr::Query::Request::Grouping.none
      end

      def sorting
        @sorting ||= Solr::Query::Request::Sorting.none
      end

      def shards_preference
        @shards_preference ||= Solr::Query::Request::ShardsPreference.none
      end

      def to_h
        Solr::Query::Request::EdismaxAdapter.new(self).to_h
      end

      private

      def run_paged(page: 1, page_size: 10, runner_options:)
        start_page = page.to_i - 1
        start_page = start_page < 1 ? 0 : start_page
        start = start_page * page_size

        Solr::Query::Handler.call(query: self, start: start, rows: page_size, runner_options: runner_options)
      end

      def run_start(rows: 10, start: 0, runner_options:)
        Solr::Query::Handler.call(query: self, start: start, rows: rows, runner_options: runner_options)
      end
    end
  end
end
