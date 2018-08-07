module Solr
  class Response
    class SolrError
      class None < SolrError
        def initialize
          super(code: nil, message: nil)
          freeze
        end

        def inspect
          'SolrError: None'
        end
      end

      def self.none()
        None.new
      end

      attr_reader :code, :message
      def initialize(code:, message:)
        @code = code
        @message = message
        freeze
      end


      def inspect
        "#{message} (#{code})"
      end
    end
  end
end