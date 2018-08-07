module Solr
  module Indexing
    class Request
      include Solr::ConnectionHelper

      # TODO: potentially make handlers configurable and have them handle the path
      PATH = '/update'.freeze

      attr_reader :docs

      def initialize(docs)
        @docs = docs
      end

      def run(commit: false)
        # need to think how to move out commit data from the connection, it doesn't belong there
        raw_response = connection(PATH, commit: commit).post_as_json(docs)
        Solr::Response.from_raw_response(raw_response)
      end
    end
  end
end
