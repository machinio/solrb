module Solr
  module Request
    class DefaultNodeSelectionStrategy < NodeSelectionStrategy
      def call
        Solr.active_nodes_for(collection: collection_name).shuffle
      end
    end
  end
end
