module Solr
  module Request
    class FirstShardLeaderNodeSelectionStrategy
      def self.call(collection_name)
        new(collection_name).call
      end

      def initialize(collection_name)
        @collection_name = collection_name
      end

      def call
        return [solr_url] unless Solr.cloud_enabled?

        ([first_shard_leader_replica_node_for(collection: @collection_name)] + solr_cloud_active_nodes_urls.shuffle).flatten.uniq
      end

      private

      def first_shard_leader_replica_node_for(collection:)
        shards = Solr.shards_for(collection: collection)
        return unless shards
        first_shard_name = shards.sort.first
        Solr.leader_replica_node_for(collection: collection, shard: first_shard_name)
      end

      def solr_cloud_active_nodes_urls
        Solr.active_nodes_for(collection: @collection_name)
      end
    end
  end
end
