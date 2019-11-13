module Solr
  module Request
    class DefaultNodeSelectionStrategy < NodeSelectionStrategy
      def call
        urls = Solr.active_nodes_for(collection: collection_name)
        map_urls_to_collections(urls).shuffle
      end
    end
  end
end
