module Solr
  class DocumentCollection
    include Enumerable
    attr_reader :documents, :total_count

    def self.from_ids(ids, model_name:)
      documents = ids.map { |id| Solr::Document.new(id: id, model_name: model_name) }
      new(documents: documents, total_count: documents.count)
    end

    def self.empty
      new(documents: [], total_count: 0)
    end

    def initialize(documents:, total_count:)
      @documents = documents
      @total_count = total_count
    end

    def each(&b)
      return enum_for(:each) unless block_given?
      documents.each(&b)
    end

    def first(n)
      new_documents = documents.first(n)
      self.class.new(documents: new_documents, total_count: new_documents.count)
    end

    def slice(range)
      new_documents = documents[range]
      if new_documents
        self.class.new(documents: new_documents, total_count: new_documents.count)
      else
        self.class.empty
      end
    end

    def +(other)
      self.class.new(
        documents: documents + other.documents,
        total_count: total_count + other.total_count
      )
    end

    def unshift(document)
      @documents.unshift(document)
      @total_count += 1
    end

    def document_for(record)
      documents.detect do |doc|
        doc.model_name == record.class.name && doc.id == record.id
      end
    end
  end
end
