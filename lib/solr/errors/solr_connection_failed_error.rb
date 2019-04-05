module Solr
  module Errors
    class SolrConnectionFailedError < StandardError
      def initialize(solr_url_errors)
        urls_message = solr_url_errors.map { |url, error| "[#{url}] #{error}" }.join("\n")
        message = <<~MESSAGE
          Could not connect to any available solr instance:
          #{urls_message}
        MESSAGE
        super(message)
      end
    end
  end
end
