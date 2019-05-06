module Solr
  module Request
    module MasterSlave
      class MasterNodeSelectionStrategy < NodeSelectionStrategy
        def call
          [Solr.configuration.master_url]
        end
      end
    end
  end
end
