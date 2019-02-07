module Solr
  module Request
    class DefaultNodeSelectionStrategy
      attr_reader :collection_name

      def self.call(collection_name)
        new(collection_name).call
      end

      def initialize(collection_name)
        @collection_name = collection_name
      end

      def call
        Solr.active_nodes_for(collection: collection_name).shuffle
      end
    end
  end
end
