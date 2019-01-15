

module Solr
  module Cloud
    class Configuration
      attr_reader :zookeeper, :collections, :collection_states

      def self.configure(opts)
        configuration = new(opts)
        configuration.watch_solr_collections_state
        configuration
      end

      def initialize(zookeeper:, collections:)
        @zookeeper = zookeeper
        @collections = collections
        @collection_states = {}
      end

      def shards_for(collection:)
        collection_states.dig(collection.to_s, 'shards').keys
      end

      def active_nodes_for(collection:)
        shards = collection_states.dig(collection.to_s, 'shards')
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
        shards = collection_states.dig(collection.to_s, 'shards')
        return unless shards
        shard_replicas = shards[shard.to_s]
        leader_replica = shard_replicas['replicas'].detect do |_, replica|
          replica['state'] == 'active' && replica['leader'] == 'true'
        end
        leader_replica.last['base_url'] if leader_replica
      end

      def watch_solr_collections_state
        collections.each do |collection|
          watch_collection_state(collection)
        end
      end

      private

      def watch_collection_state(collection_name)
        collection_state_znode = collection_state_znode_path(collection_name)
        zookeeper.register(collection_state_znode) do |event|
          get_collection_state(collection_name, watch: true)
        end
        get_collection_state(collection_name, watch: true)
      end

      def get_collection_state(collection_name, watch: true)
        collection_state_znode = collection_state_znode_path(collection_name)
        znode_data = zookeeper.get(collection_state_znode, watch: watch)
        return unless znode_data
        @collection_states[collection_name.to_s] = JSON.parse(znode_data)[collection_name.to_s]
      end

      def collection_state_znode_path(collection_name)
        "/collections/#{collection_name}/state.json"
      end
    end
  end
end
