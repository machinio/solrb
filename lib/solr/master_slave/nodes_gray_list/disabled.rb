module Solr
  module MasterSlave
    module NodesGrayList
      class Disabled
        def add(_)
        end

        def remove(_)
        end

        def added?(_)
          true
        end

        def select_active(urls, collection_name:)
          urls
        end
      end
    end
  end
end
