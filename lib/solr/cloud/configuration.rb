require 'zk'

module Solr
  module Cloud
    class Configuration
      attr_reader :zookeeper_url, :collections, :collection_states

      def self.configure(zookeeper_url, collections)
        configuration = new(zookeeper_url, collections)
        configuration.watch_solr_collections_state
        configuration
      end

      def initialize(zookeeper_url, collections)
        @zookeeper_url = zookeeper_url
        @collections = collections
        @collection_states = {}
      end

      def active_nodes_for(collection:)
        collection_state = collection_states.dig(collection.to_s, 'shards')
        return unless collection_state
        collection_state.flat_map do |_, shard|
          shard['replicas'].select do |_, replica|
            replica['state'] == 'active'
          end.flat_map do |_, replica|
            replica['base_url']
          end
        end.uniq
      end

      # This is a very simple way of finding a leader node and it does not take sharding into account.
      # Right now it's assuming a cluster with single shard.
      # For multiple shards a document id would be required as an argument to find the shard leader based
      # on the shard range.
      def leader_node_for(collection:)
        collection_state = collection_states.dig(collection.to_s, 'shards')
        return unless collection_state
        collection_state.flat_map do |_, shard|
          shard['replicas'].find do |_, replica|
            replica['state'] == 'active' && replica['leader'] == 'true'
          end
        end.last['base_url']
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
        znode_data = zookeeper.get(collection_state_znode, watch: watch).first
        return unless znode_data
        @collection_states[collection_name.to_s] = JSON.parse(znode_data)[collection_name.to_s]
      end

      def zookeeper
        @zookeeper ||= ZK.new(zookeeper_url)
      end

      def collection_state_znode_path(collection_name)
        "/collections/#{collection_name}/state.json"
      end
    end
  end
end
