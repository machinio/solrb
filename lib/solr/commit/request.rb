module Solr
  module Commit
    class Request
      include Solr::Support::ConnectionHelper
      PATH = '/update'.freeze

      def run
        Solr::Support::RequestRunner.post(PATH, {}, commit: true)
      end
    end
  end
end
