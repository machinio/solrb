module Solr
  module Indexing
    class Request
      include Solr::Support::ConnectionHelper

      # TODO: potentially make handlers configurable and have them handle the path
      CORE_ACTION = 'update'.freeze

      attr_reader :core_name, :docs

      def initialize(core_name:, docs:)
        @core_name = core_name.to_s
        @docs = docs
      end

      def run(commit: false)
        # need to think how to move out commit data from the connection, it doesn't belong there
        raw_response = connection(path, commit: commit).post_as_json(docs)
        Solr::Response.from_raw_response(raw_response)
      end

      private

      def path
        File.join('/', core_name, CORE_ACTION)
      end
    end
  end
end
