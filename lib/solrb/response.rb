module Solr
  class Response
    attr_reader :documents, :available_facets, :spellcheck

    class << self
      def empty
        new(documents: Solr::DocumentCollection.empty)
      end

      def empty_grouped
        new(documents: Solr::GroupedDocumentCollection.empty)
      end

      # TODO extract this
      def manual_grouped_listing_documents(listing_ids)
        documents = listing_ids.map { |id| Solr::Document.new(id: id, model_name: 'Listing') }
        group_counts = listing_ids.reduce({}) do |acc, id|
          acc[id] = 1
          acc
        end
        new(documents: Solr::GroupedDocumentCollection.new(
          documents: documents,
          total_count: listing_ids.count,
          group_counts: group_counts
        ))
      end
    end

    def initialize(documents:, available_facets: [], spellcheck: Solr::Response::Spellcheck.empty)
      @documents = documents
      @available_facets = available_facets
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
