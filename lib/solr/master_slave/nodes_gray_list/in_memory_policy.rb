module Solr
  module MasterSlave
    module NodesGrayList
      class InMemoryPolicy
        attr_reader :gray_list, :removal_period

        DEFAULT_REMOVAL_PERIOD = 5 * 60 # 5 minutes in seconds
        
        def initialize(removal_period: DEFAULT_REMOVAL_PERIOD)
          @gray_list = {}
          @removal_period = removal_period
        end
        
        def add(url)
          gray_list[url] ||= Time.now.utc
        end

        def remove(url)
          gray_list.delete(url)
        end

        def active?(url)
          added_at = gray_list[url]
          return true unless added_at

          if added_at + removal_period < Time.now.utc
            false
          else
            remove(url)
            true
          end
        end

        def filter_active(urls)
          active_urls = urls.select(&method(:active?))
          active_urls.any? ? active_urls : urls
        end
      end
    end
  end
end
