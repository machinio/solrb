require 'solr/master_slave/nodes_gray_list/disabled'
require 'solr/master_slave/nodes_gray_list/in_memory'

module Solr
  module MasterSlave
    class Configuration
      attr_accessor :disable_read_from_master

      attr_reader :master_slave_enabled
      attr_writer :master_url, :slave_url
      attr_writer :nodes_gray_list

      def enable_master_slave!(_)
        @master_slave_enabled = true
      end

      def master_slave_enabled?
        @master_slave_enabled
      end

      def master_url
        @master_url || ENV['SOLR_MASTER_URL']
      end

      def slave_url
        @slave_url || ENV['SOLR_SLAVE_URL']
      end

      def active_nodes_for(collection:)
        urls = []
        urls.push(master_url) unless disable_read_from_master
        urls.push(*slave_url) if slave_url
        nodes_gray_list.select_active(urls, collection_name: collection)
      end

      def nodes_gray_list
        @nodes_gray_list || gray_list_disabled_instance
      end

      private

      def gray_list_disabled_instance
        @gray_list_disabled_instance ||= Solr::MasterSlave::NodesGrayList::Disabled.new
      end
    end
  end
end
