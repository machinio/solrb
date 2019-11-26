require 'solr/query/response/expanded_result_set'
require 'solr/query/response/facet_value'
require 'solr/query/response/field_facets'
require 'solr/query/response/parser'
require 'solr/query/response/spellcheck'

module Solr
  module Query
    class Response
      attr_reader :documents, :available_facets, :spellcheck, :expanded_results

      class << self
        def empty
          new(documents: Solr::DocumentCollection.empty)
        end

        def empty_grouped
          new(documents: Solr::GroupedDocumentCollection.empty)
        end

        def manual_grouped_documents(ids)
          documents = ids.map { |id| Solr::Document.new(id: id) }
          group_counts = ids.each_with_object({}) do |id, acc|
            acc[id] = 1
          end
          new(documents: Solr::GroupedDocumentCollection.new(
            documents: documents,
            total_count: ids.count,
            group_counts: group_counts
          ))
        end
      end

      def initialize(documents:, available_facets: [], spellcheck: Solr::Query::Response::Spellcheck.empty, expanded_results: [])
        @documents = documents
        @available_facets = available_facets
        @expanded_results = expanded_results
        @spellcheck = spellcheck
      end

      def total_count
        @documents.total_count
      end

      def empty?
        total_count.zero?
      end
    end
  end
end
