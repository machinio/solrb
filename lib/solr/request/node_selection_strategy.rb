module Solr
  module Request
    class NodeSelectionStrategy
      attr_reader :collection_name

      def self.call(collection_name)
        new(collection_name).call
      end

      def initialize(collection_name)
        @collection_name = collection_name
      end

      def call
        raise "Not implemented"
      end
    end
  end
end
