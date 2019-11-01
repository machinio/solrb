require 'solr/master_slave/nodes_gray_list/disabled_policy'
require 'solr/master_slave/nodes_gray_list/in_memory_policy'

module Solr
  module MasterSlave
    class Configuration
      attr_accessor :master_url, :slave_url, :disable_read_from_master

      attr_reader :master_slave_enabled
      attr_writer :nodes_gray_list_policy

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

      def nodes_gray_list_policy
        nodes_gray_list_policy || gray_list_disabled_policy_instance
      end

      private

      def gray_list_disabled_policy_instance
        @gray_list_disabled_policy_instance ||= Solr::MasterSlave::NodesGrayList::DisabledPolicy.new
      end
    end
  end
end
