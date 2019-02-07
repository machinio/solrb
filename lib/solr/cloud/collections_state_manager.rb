module Solr
  module Cloud
    class CollectionsStateManager
      attr_reader :zookeeper, :collections, :collections_state

      def initialize(zookeeper:, collections:)
        @zookeeper = zookeeper
        @collections = collections
        @collections_state = {}
        watch_solr_collections_state
      end

      def shards_for(collection:)
        collections_state.dig(collection.to_s, 'shards').keys
      end

      def active_nodes_for(collection:)
        shards = collections_state.dig(collection.to_s, 'shards')
        return unless shards
        shards.flat_map do |_, shard|
          shard['replicas'].select do |_, replica|
            replica['state'] == 'active'
          end.flat_map do |_, replica|
            replica['base_url']
          end
        end.uniq
      end

      def leader_replica_node_for(collection:, shard:)
        shards = collections_state.dig(collection.to_s, 'shards')
        return unless shards
        shard_replicas = shards[shard.to_s]
        leader_replica = shard_replicas['replicas'].detect do |_, replica|
          replica['state'] == 'active' && replica['leader'] == 'true'
        end
        leader_replica.last['base_url'] if leader_replica
      end

      def watch_solr_collections_state
        collections.each do |collection_name|
          zookeeper.watch_collection_state(collection_name) do |state|
            @collections_state[collection_name.to_s] = state
          end
        end
      end
    end
  end
end
