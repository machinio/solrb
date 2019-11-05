module Solr
  module Request
    module MasterSlave
      class DefaultNodeSelectionStrategy < NodeSelectionStrategy
        def call
          urls = Solr.active_nodes_for(collection: collection_name)
          node_urls = map_urls_to_collections(urls).shuffle
          Solr.configuration.nodes_gray_list.select_active(node_urls)
        end
      end
    end
  end
end
