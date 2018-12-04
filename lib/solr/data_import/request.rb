module Solr
  module DataImport
    class Request
      include Solr::Support::ConnectionHelper

      PATH = '/dataimport'.freeze

      attr_reader :params

      def initialize(params)
        @params = params
      end

      def run
        Solr::Request::Runner.get(PATH, params)
      end
    end
  end
end
