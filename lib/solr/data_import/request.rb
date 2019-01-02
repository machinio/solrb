require 'solr/request/solr_cloud_leader_router'

module Solr
  module DataImport
    class Request
      PATH = '/dataimport'.freeze

      attr_reader :params

      def initialize(params)
        @params = params
      end

      def run
        request_router.run(path: PATH,
                           url_params: params,
                           request_params: {},
                           method: :get)
      end

      private

      def request_router
        Solr.cloud_enabled? ? Solr::Request::SolrCloudLeaderRouter : Solr::Request::SingleSolrInstanceRouter
      end
    end
  end
end
