require 'solr/errors/solr_query_error'

module Solr
  module Admin
    class CollectionService
      def create(name:, config_set: '_default', num_shards: 1, replication_factor: 1, max_shards_per_node: nil)
        params = {
          action: 'CREATE',
          name: name,
          'collection.configName': config_set,
          numShards: num_shards,
          replicationFactor: replication_factor
        }

        params[:maxShardsPerNode] = max_shards_per_node if max_shards_per_node

        url = Solr::Support::UrlHelper.build_request_url(
          url: Solr::Support::UrlHelper.admin_base_url_for_collections,
          path: 'admin/collections',
          url_params: params
        )

        response = Solr::Connection.call(url: url, method: :get, body: nil)
        handle_response(response)
      end

      def delete(name:)
        params = {
          action: 'DELETE',
          name: name
        }

        url = Solr::Support::UrlHelper.build_request_url(
          url: Solr::Support::UrlHelper.admin_base_url_for_collections,
          path: 'admin/collections',
          url_params: params
        )

        response = Solr::Connection.call(url: url, method: :get, body: nil)
        handle_response(response)
      end

      def reload(name:)
        params = {
          action: 'RELOAD',
          name: name
        }

        url = Solr::Support::UrlHelper.build_request_url(
          url: Solr::Support::UrlHelper.admin_base_url_for_collections,
          path: 'admin/collections',
          url_params: params
        )

        response = Solr::Connection.call(url: url, method: :get, body: nil)
        handle_response(response)
      end

      def list
        params = {
          action: 'LIST'
        }

        url = Solr::Support::UrlHelper.build_request_url(
          url: Solr::Support::UrlHelper.admin_base_url_for_collections,
          path: 'admin/collections',
          url_params: params
        )

        response = Solr::Connection.call(url: url, method: :get, body: nil)
        handle_response(response)
      end

      def exists?(name:)
        response = list
        response['collections'].include?(name.to_s)
      rescue StandardError
        false
      end

      private

      def handle_response(response)
        return JSON.parse(response.body) if response.status == 200

        error = JSON.parse(response.body) rescue nil
        if error && error['error']
          raise Solr::Errors::SolrQueryError, error['error']['msg']
        else
          raise Solr::Errors::SolrQueryError, "Request failed with status #{response.status}"
        end
      end
    end
  end
end
