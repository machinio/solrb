module Solr
  module Errors
    class SolrUrlNotDefinedError < StandardError
      SOLR_URL_NOT_DEFINED_MESSAGE = '
        Solrb gem requires you to set the URL of your Solr instance
        either through SOLR_URL environmental variable or explicitly inside the configure block:

        Solr.configure do |config|
          config.url = "http://localhost:8983/solr/core"
        end

        If you are using Solr cloud you can specify the zookeeper ensemble urls inside the configure block
        and solrb will automatically get the solr urls from ZK:

        Solr.configure do |config|
          config.zookeeper_url = "localhost:2181,localhost:2182,localhost:2183"
        end

        For more information please check the solrb README file.

      '.freeze

      def initialize
        super(SOLR_URL_NOT_DEFINED_MESSAGE)
      end
    end
  end
end

