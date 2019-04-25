require 'solr/master_slave/configuration'

module Solr
  module MasterSlave
    module HelperMethods
      def master_slave_active_nodes_for(collection:)
        master_slave_configuration.active_nodes_for(collection: collection)
      end

      def master_slave_enabled?
        master_slave_configuration.master_slave_enabled?
      end

      def enable_master_slave!
        master_slave_configuration.enable_master_slave!(configuration.cores.keys)
      end

      private

      def master_slave_configuration
        configuration.master_slave_configuration
      end
    end
  end
end
