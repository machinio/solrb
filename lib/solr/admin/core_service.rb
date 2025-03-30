require 'solr/errors/solr_query_error'

module Solr
  module Admin
    class CoreService
      def create(name:, config_set: '_default', config_dir: nil, schema_file: nil, data_dir: nil)
        params = {
          action: 'CREATE',
          name: name,
          configSet: config_set
        }

        params[:configDir] = config_dir if config_dir
        params[:schema] = schema_file if schema_file
        params[:dataDir] = data_dir if data_dir

        url = Solr::Support::UrlHelper.build_request_url(
          url: Solr::Support::UrlHelper.admin_base_url_for_cores,
          path: 'admin/cores',
          url_params: params
        )

        response = Solr::Connection.call(url: url, method: :get, body: nil)
        handle_response(response)
      end

      # Unloads a core from Solr. To completely remove a core, use unload with delete options.
      # @param name [String] The name of the core to unload
      # @param delete_index [Boolean] If true, will remove the index when unloading
      # @param delete_data_dir [Boolean] If true, removes the data directory and all sub-directories
      # @param delete_instance_dir [Boolean] If true, removes everything related to the core
      def unload(name:, delete_index: false, delete_data_dir: false, delete_instance_dir: false)
        params = {
          action: 'UNLOAD',
          core: name,
          deleteIndex: delete_index,
          deleteDataDir: delete_data_dir,
          deleteInstanceDir: delete_instance_dir
        }

        url = Solr::Support::UrlHelper.build_request_url(
          url: Solr::Support::UrlHelper.admin_base_url_for_cores,
          path: 'admin/cores',
          url_params: params
        )

        response = Solr::Connection.call(url: url, method: :get, body: nil)
        handle_response(response)
      end

      def reload(name:)
        params = {
          action: 'RELOAD',
          core: name
        }

        url = Solr::Support::UrlHelper.build_request_url(
          url: Solr::Support::UrlHelper.admin_base_url_for_cores,
          path: 'admin/cores',
          url_params: params
        )

        response = Solr::Connection.call(url: url, method: :get, body: nil)
        handle_response(response)
      end

      def rename(name:, new_name:)
        params = {
          action: 'RENAME',
          core: name,
          other: new_name
        }

        url = Solr::Support::UrlHelper.build_request_url(
          url: Solr::Support::UrlHelper.admin_base_url_for_cores,
          path: 'admin/cores',
          url_params: params
        )

        response = Solr::Connection.call(url: url, method: :get, body: nil)
        handle_response(response)
      end

      def status(name: nil)
        params = { action: 'STATUS' }
        params[:core] = name if name

        url = Solr::Support::UrlHelper.build_request_url(
          url: Solr::Support::UrlHelper.admin_base_url_for_cores,
          path: 'admin/cores',
          url_params: params
        )

        response = Solr::Connection.call(url: url, method: :get, body: nil)
        handle_response(response)
      end

      def exists?(name:)
        response = status(name: name)
        response.dig('status', name.to_s) != {}
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
