module Errors
  class SolrUrlNotDefinedError < StandardError
    SOLR_URL_NOT_DEFINED_MESSAGE = '
      Solrb gem requires you to set the URL of your Solr instance
      either through SOLR_URL environmental variable or explicitly inside the configure block:

      Solr.configure do |config|
        config.url = "http://localhost:8983/solr/core"
      end
    '.freeze

    def initialize
      super(SOLR_URL_NOT_DEFINED_MESSAGE)
    end
  end
end
