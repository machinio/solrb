module Solr
  module Request
    class SingleSolrInstanceRouter
      include Solr::Support::UrlHelper

      attr_reader :path, :url_params, :request_params, :method

      def self.run(opts)
        new(opts).run
      end

      def initialize(path:, url_params: {}, request_params: {}, method: :post)
        @path = path
        @url_params = url_params
        @request_params = request_params
        @method = method
      end

      def run
        request_url = build_request_url(url: solr_url,
                                        collection_name: active_collection_name,
                                        path: path,
                                        url_params: url_params)
        raw_response = Solr::Connection.new(request_url).public_send(method, request_params)
        Solr::Response.from_raw_response(raw_response)
      end

      private

      def solr_url
        Solr.configuration.url || ENV['SOLR_URL']
      end

      def active_collection_name
        Solr.current_core_config.name.to_s
      end
    end
  end
end
