require 'solr/request/single_solr_instance_request_router'
require 'solr/request/solr_cloud_request_router'

module Solr
  module Request
    class Runner
      class << self
        def post_as_json(path, request_params, url_params = {})
          run_request(path, request_params, url_params, :post_as_json)
        end

        def post(path, request_params, url_params = {})
          run_request(path, request_params, url_params, :post)
        end

        def run_request(path, request_params, url_params = {}, method)
          selected_router.run(path: path,
                              url_params: url_params,
                              request_params: request_params,
                              method: method)
        end

        private

        def selected_router
          Solr.cloud_enabled? ? Request::SolrCloudRequestRouter : Request::SingleSolrInstanceRequestRouter
        end
      end
    end
  end
end
