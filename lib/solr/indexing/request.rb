module Solr
  module Indexing
    class Request
      include Solr::Support::ConnectionHelper

      # TODO: potentially make handlers configurable and have them handle the path
      SOLR_UPDATE_ACTION = 'update'.freeze

      attr_reader :core_name, :documents

      def initialize(core_name:, documents:)
        @core_name = core_name.to_s
        @documents = documents
      end

      def run(commit: false)
        # need to think how to move out commit data from the connection, it doesn't belong there
        data = documents.map { |d| d.as_json(core_name: core_name) }
        raw_response = connection(path, commit: commit).post_as_json(data)
        Solr::Response.from_raw_response(raw_response)
      end

      private

      def path
        File.join('/', core_name.to_s, SOLR_UPDATE_ACTION)
      end
    end
  end
end
