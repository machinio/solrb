module Solr
  module Indexing
    class Request
      include Solr::Support::ConnectionHelper

      # TODO: potentially make handlers configurable and have them handle the path
      PATH = '/update'.freeze

      attr_reader :core, :documents

      def initialize(core: nil, documents:)
        @core = core || Solr.configuration.default_core
        @documents = documents
      end

      def run(commit: false)
        # need to think how to move out commit data from the connection, it doesn't belong there
        data = documents.map { |d| d.as_json(core: core) }
        raw_response = connection(PATH, core: core, commit: commit).post_as_json(data)
        Solr::Response.from_raw_response(raw_response)
      end
    end
  end
end
