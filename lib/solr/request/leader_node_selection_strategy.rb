module Solr
  module Request
    class LeaderNodeSelectionStrategy
      attr_reader :shard

      def initialize(shard:)
        @shard = shard
      end

      def call(collection_name)
        return [solr_url] unless Solr.cloud_enabled?

        ([first_shard_leader_replica_node_for(collection: collection)] + solr_cloud_active_nodes_urls.shuffle).flatten.uniq
      end

      private

      def first_shard_leader_replica_node_for(collection: collection)
        shards_info = shards_for(collection: collection)
        return unless shards_info
        first_shard_name = shards_info.keys.sort.first
        Solr.leader_replica_node_for(collection: collection, shard: first_shard_name)
      end

      def solr_cloud_active_nodes_urls
        Solr.active_nodes_for(collection: collection_name)
      end
    end
  end
end
