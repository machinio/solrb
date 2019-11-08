module Solr
  module MasterSlave
    module NodesGrayList
      class InMemory
        attr_reader :gray_list, :removal_period

        DEFAULT_REMOVAL_PERIOD = 5 * 60 # 5 minutes in seconds
        
        def initialize(removal_period: DEFAULT_REMOVAL_PERIOD)
          @gray_list = {}
          @removal_period = removal_period
        end
        
        def add(url)
          return if gray_list.has_key?(url)
          ::Solr.configuration.logger.info("#{url} added to a gray list")
          gray_list[url] = Time.now.utc
        end

        def remove(url)
          gray_list.delete(url)
        end

        def added?(url)
          added_at = gray_list[url]
          return false unless added_at

          if added_at + removal_period < Time.now.utc
            true
          else
            remove(url)
            false
          end
        end

        def select_active(urls, collection_name:)
          urls = Array(urls)
          active_urls = urls.reject do |url|
            collection_url = File.join(url, collection_name.to_s)
            added?(collection_url)
          end
          active_urls.any? ? active_urls : urls
        end
      end
    end
  end
end
