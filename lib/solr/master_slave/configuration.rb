module Solr
  module MasterSlave
    class Configuration
      attr_accessor :master_url, :slave_url, :disable_read_from_master

      attr_reader :master_slave_enabled

      def enable_master_slave!(_)
        @master_slave_enabled = true
      end

      def master_slave_enabled?
        @master_slave_enabled
      end

      def active_nodes_for(**_options)
        nodes = []
        nodes.push(master_url) unless disable_read_from_master
        nodes.push(*slave_url) if slave_url
        nodes
      end
    end
  end
end
