require 'solr/cloud/zookeeper_connection'
require 'solr/cloud/collections_state_manager'

module Solr
  module Cloud
    class Configuration
      attr_accessor :zookeeper_url, :zookeeper_auth_user, :zookeeper_auth_password

      attr_reader :collections_state_manager

      def enable_solr_cloud!(collections)
        @collections_state_manager = Solr::Cloud::CollectionsStateManager.new(zookeeper: build_zookeeper_connection,
                                                                              collections: collections)
      end

      def cloud_enabled?
        !@collections_state_manager.nil?
      end

      def build_zookeeper_connection
        Solr::Cloud::ZookeeperConnection.new(zookeeper_url: zookeeper_url.is_a?(Array) ? zookeeper_url.join(',') : zookeeper_url,
                                             zookeeper_auth_user: zookeeper_auth_user,
                                             zookeeper_auth_password: zookeeper_auth_password)
      end
    end
  end
end
