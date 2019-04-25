require 'solr/cloud/configuration'

module Solr
  module Cloud
    module HelperMethods
      def cloud_active_nodes_for(collection:)
        collections_state_manager.active_nodes_for(collection: collection)
      end

      def leader_replica_node_for(collection:, shard:)
        collections_state_manager.leader_replica_node_for(collection: collection, shard: shard)
      end

      def shards_for(collection:)
        collections_state_manager.shards_for(collection: collection)
      end

      def cloud_enabled?
        cloud_configuration.cloud_enabled?
      end

      def enable_solr_cloud!
        cloud_configuration.enable_solr_cloud!(configuration.cores.keys)
      end

      private

      def collections_state_manager
        cloud_configuration.collections_state_manager
      end

      def cloud_configuration
        configuration.cloud_configuration
      end
    end
  end
end
