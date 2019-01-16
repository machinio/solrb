require 'solr/errors/zookeeper_required'

module Solr
  module Cloud
    class ZookeeperConnection
      attr_reader :zookeeper_url, :zookeeper_auth_user, :zookeeper_auth_password

      def initialize(zookeeper_url:, zookeeper_auth_user: nil, zookeeper_auth_password: nil)
        @zookeeper_url = zookeeper_url
        @zookeeper_auth_user = zookeeper_auth_user
        @zookeeper_auth_password = zookeeper_auth_password
      end

      def watch_collection_state(collection_name, &block)
        collection_state_znode = collection_state_znode_path(collection_name)
        zookeeper_connection.register(collection_state_znode) do |event|
          state = get_collection_state(collection_name, watch: true)
          block.call(state)
        end
        state = get_collection_state(collection_name, watch: true)
        block.call(state)
      end

      def get_collection_state(collection_name, watch: true)
        collection_state_znode = collection_state_znode_path(collection_name)
        znode_data = zookeeper_connection.get(collection_state_znode, watch: watch)
        return unless znode_data
        JSON.parse(znode_data.first)[collection_name.to_s]
      end

      def collection_state_znode_path(collection_name)
        "/collections/#{collection_name}/state.json"
      end

      private

      def zookeeper_connection
        @zookeeper_connection ||= build_zookeeper_connection
      end

      def build_zookeeper_connection
        raise 'You must provide a ZooKeeper URL to enable solr cloud mode' unless zookeeper_url
        raise Solr::Errors::ZookeeperRequired unless require_zk

        zk = ZK.new(zookeeper_url)
        zk.add_auth(scheme: 'digest', cert: zookeeper_auth) if zookeeper_auth
        zk
      end

      def zookeeper_auth
        if zookeeper_auth_user && zookeeper_auth_password
          "#{zookeeper_auth_user}:#{zookeeper_auth_password}"
        end
      end

      def require_zk
        require 'zk'
        true
      rescue LoadError
        false
      end
    end
  end
end
