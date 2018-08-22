module Solr
  module Indexing
    class Request
      include Solr::Support::ConnectionHelper

      # TODO: potentially make handlers configurable and have them handle the path
      SOLR_UPDATE_ACTION = '/update'.freeze

      attr_reader :core_name, :documents

      def initialize(core_name: nil, documents:)
        @core_name = core_name
        @documents = documents
      end

      def run(commit: false)
        # need to think how to move out commit data from the connection, it doesn't belong there
        data = documents.map { |d| d.as_json(core_name: core_name || Solr.configuration.default_core_name) }
        raw_response = connection(SOLR_UPDATE_ACTION, core_name: core_name, commit: commit).post_as_json(data)
        Solr::Response.from_raw_response(raw_response)
      end
    end
  end
end
