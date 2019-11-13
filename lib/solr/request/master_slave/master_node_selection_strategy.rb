module Solr
  module Request
    module MasterSlave
      class MasterNodeSelectionStrategy < NodeSelectionStrategy
        def call
          urls = [Solr.configuration.master_url]
          map_urls_to_collections(urls)
        end
      end
    end
  end
end
