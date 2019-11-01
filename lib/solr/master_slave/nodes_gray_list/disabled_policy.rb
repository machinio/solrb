module Solr
  module MasterSlave
    module NodesGrayList
      class DisabledPolicy
        def add(_)
        end

        def remove(_)
        end

        def active?(_)
          true
        end

        def filter_active(urls)
          urls
        end
      end
    end
  end
end
