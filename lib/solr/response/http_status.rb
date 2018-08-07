module Solr
  class Response
    class HttpStatus
      
      class << self
        def ok
          new(status: 200, message: 'OK')
        end

        def not_found
          new(status: 404, message: 'Not Found')
        end
      end

      attr_reader :status, :message

      def initialize(status:, message:)
        @status = status
        @message = message
        freeze
      end

      def inspect
        "#{status} (#{message})"
      end
    end
  end
end