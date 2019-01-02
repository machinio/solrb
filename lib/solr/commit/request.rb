module Solr
  module Commit
    class Request
      PATH = '/update'.freeze

      def run
        Solr::Request::Runner.post(PATH, {}, commit: true)
      end
    end
  end
end
