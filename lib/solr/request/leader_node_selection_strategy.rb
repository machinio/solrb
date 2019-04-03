module Solr
  module Request
    class LeaderNodeSelectionStrategy
      def self.call(collection_name)
        new(collection_name).call
      end

      def initialize(collection_name)
        @collection_name = collection_name
      end

      def call
        return [solr_url] unless Solr.cloud_enabled?

        [leader_replica_node_for(collection: @collection_name)]
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
