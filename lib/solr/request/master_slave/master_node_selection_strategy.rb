module Solr
  module Request
    module MasterSlave
      class MasterNodeSelectionStrategy < NodeSelectionStrategy
        def call
          urls = [Solr.configuration.master_url]
          node_urls = map_urls_to_collections(urls)
          Solr.configuration.nodes_gray_list.select_active(node_urls)
        end
      end
    end
  end
end
