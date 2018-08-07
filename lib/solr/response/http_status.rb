module Solr
  class Response
    class HttpStatus
      def self.ok
        new(status: 200, message: :OK)
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