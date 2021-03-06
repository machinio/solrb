module Solr
  module Request
    module Cloud
      class FirstShardLeaderNodeSelectionStrategy < NodeSelectionStrategy
        def call
          leader = first_shard_leader_replica_node_for(collection: collection_name)
          replicas = solr_cloud_active_nodes_urls.shuffle
          urls = ([leader] + replicas).flatten.uniq
          map_urls_to_collections(urls)
        end

        private

        def first_shard_leader_replica_node_for(collection:)
          shards = Solr.shards_for(collection: collection)
          return unless shards
          first_shard_name = shards.sort.first
          Solr.leader_replica_node_for(collection: collection, shard: first_shard_name)
        end

        def solr_cloud_active_nodes_urls
          Solr.active_nodes_for(collection: collection_name)
        end
      end
    end
  end
end
