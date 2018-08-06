module Solr
  class BasicResponse
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

    class << self
      def from_raw_response(response)
        if response.status >= 300
          process_http_error(response)
        else
          parsed_response = JSON.parse(response.body)
          solr_status = parsed_response['responseHeader']['status'].to_i
          # TODO: see what statuses solr can return
          status = solr_status.zero? ? :OK : solr_status
          time = parsed_response['responseHeader']['QTime'].to_i
          new(status: status, time: time)
        end
      end

      private

      def process_http_error(response)
        http_status = HttpStatus.new(status: response.status, message: response.reason_phrase)
        new(status: 'ERROR', http_status: http_status)
      end
    end

    attr_reader :status, :time, :http_status

    def initialize(status:, time: 0, http_status: HttpStatus.ok)
      @status = status
      @time = time
      @http_status = http_status
      freeze
    end
  end
end