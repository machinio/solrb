module Solr
  module Indexing
    class Request
      # TODO: potentially make handlers configurable and have them handle the path
      PATH = '/update'.freeze

      include Solr::UrlUtils

      def initialize(docs, commit: false)
        @docs = docs
        @commit = commit
      end

      def run
        raw_response = connection.post_as_json(@docs)
        Solr::BasicResponse.from_raw_response(raw_response)
      end

      private

      def connection
        @connection ||= begin
          url_params = {}
          url_params[:commit] = true if @commit
          url = solr_url(PATH, url_params)
          Solr::Connection.new(url)
        end
      end
    end
  end
end