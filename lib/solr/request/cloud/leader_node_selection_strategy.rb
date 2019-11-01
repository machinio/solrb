module Solr
  module Request
    module Cloud
      class LeaderNodeSelectionStrategy < NodeSelectionStrategy
        def call
          urls = [leader_replica_node_for(collection: collection_name)]
          map_urls_to_collections(urls)
        end

        private

        def leader_replica_node_for(collection:)
          shards = Solr.shards_for(collection: collection)
          return unless shards
          first_shard_name = shards.sort.first
          Solr.leader_replica_node_for(collection: collection, shard: first_shard_name)
        end
      end
    end
  end
end
