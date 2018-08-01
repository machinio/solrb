module Solr
  module Indexing
    class Request
      # TODO: potentially make handlers configurable and have them handle the path
      PATH = '/update'.freeze

      include Solr::UrlUtils

      def initialize(docs)
        @docs = docs
      end

      def run
        raw_response = connection.post_as_json(@docs)
        Solr::BasicResponse.from_raw_response(raw_response.body)
      end

      private

      def connection
        @connection ||= begin
          Solr::Connection.new(solr_url(PATH))
        end
      end
    end
  end
end