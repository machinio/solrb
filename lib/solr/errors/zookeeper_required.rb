module Solr
  module Errors
    class ZookeeperRequired < StandardError
      ZOOKEEPER_REQUIRED_MESSAGE = '

        Solrb gem requires zookeeper for solr-cloud support.
        Please add "zk" gem to your Gemfile and run bundle install:

        gem "zk"

      '.freeze

      def initialize
        super(ZOOKEEPER_REQUIRED_MESSAGE)
      end
    end
  end
end

