module Solr
  module Indexing
    class Request
      include Solr::Support::ConnectionHelper

      # TODO: potentially make handlers configurable and have them handle the path
      PATH = '/update'.freeze

      attr_reader :documents

      def initialize(documents = [])
        @documents = documents
      end

      def run(commit: false)
        Solr::Support::RequestRunner.post_as_json(PATH, documents, commit: commit)
      end
    end
  end
end
