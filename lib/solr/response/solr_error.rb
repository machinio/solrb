module Solr
  class Response
    class SolrError
      attr_reader :code, :message
      def initialize(code:, message:)
        @code = code
        @message = message
        freeze
      end

      def inspect
        "#{message} (#{code})"
      end
      
      class None < SolrError
      end

      def self.none
        None.new
      end
    end
  end
end