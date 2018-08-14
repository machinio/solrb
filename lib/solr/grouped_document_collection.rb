module Solr
  class GroupedDocumentCollection < DocumentCollection
    attr_reader :group_counts

    def self.empty
      new(documents: [], total_count: 0, group_counts: {})
    end

    def initialize(documents:, total_count:, group_counts:)
      super(documents: documents, total_count: total_count)
      @group_counts = group_counts
    end

    def first(n)
      new_documents = documents.first(n)
      self.class.new(documents: new_documents,
                     total_count: new_documents.count, group_counts: group_counts)
    end

    def slice(range)
      new_documents = documents[range]
      if new_documents
        self.class.new(documents: new_documents, total_count: new_documents.count, group_counts: group_counts)
      else
        self.class.empty
      end
    end

    def +(other)
      other_group_counts = other.is_a?(Solr::GroupedDocumentCollection) ? other.group_counts : {}
      self.class.new(
        documents: documents + other.documents,
        total_count: total_count + other.total_count,
        group_counts: group_counts.merge(other_group_counts)
      )
    end
  end
end
