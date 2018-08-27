module Solr
  module Commit
    class Request
      include Solr::Support::ConnectionHelper
      PATH = '/update'.freeze

      def run
        # the way to do commit message in SOLR is to send an empty 
        # request with ?commit=true in the URL.
        raw_response = connection(PATH, commit: true).get
        Solr::Response.from_raw_response(raw_response)
      end
    end
  end
end
