module Solr
  module Indexing
    class Request
      include Solr::Support::ConnectionHelper

      # TODO: potentially make handlers configurable and have them handle the path
      PATH = '/update'.freeze

      attr_reader :documents

      def initialize(documents:)
        @documents = documents
      end

      def run(commit: false)
        # need to think how to move out commit data from the connection, it doesn't belong there
        data = documents.map { |d| d.as_json }
        raw_response = connection(PATH, commit: commit).post_as_json(data)
        Solr::Response.from_raw_response(raw_response)
      end
    end
  end
end
