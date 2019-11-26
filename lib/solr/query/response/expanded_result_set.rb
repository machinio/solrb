module Solr
  module Query
    class Response
      class ExpandedResultSet
        include Enumerable

        attr_reader :field_value, :documents

        def initialize(field_value:, documents: [])
          @field_value = field_value
          @documents = documents
          freeze
        end

        def each(&b)
          return enum_for(:each) unless block_given?
          documents.each(&b)
        end
      end
    end
  end
end
