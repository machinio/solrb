module Solr
  module Errors
    class SolrConnectionFailedError < StandardError
      def initialize(solr_urls)
        message = <<~MESSAGE
          Could not connection to any available solr instance:
          #{solr_urls.join(', ')}
        MESSAGE
        super(message)
      end
    end
  end
end
