module Solr
  module Request
    class BaseHttpRequest
      PATH = '/'.freeze

      def path
        PATH
      end

      def body
        {}
      end

      def url_params
        {}
      end

      def method
        :get
      end
    end
  end
end
