module Solr
  module Indexing
    class Request
      # TODO: potentially make handlers configurable and have them handle the path
      PATH = '/update'.freeze

      attr_reader :documents

      def initialize(documents = [])
        @documents = documents
      end

      def run(commit: false)
        Solr::Request::Runner.post_as_json(PATH, documents, commit: commit)
      end
    end
  end
end
