module Solr
  class BasicResponse
    class Header
      attr_reader :status, :time

      def initialize(status:, time:)
        @status = status
        @time = time
        freeze
      end

      def ok?
        status.zero?
      end

      def inspect
        if ok?
          'OK'
        else
          "#{status}"
        end
      end
    end
  end
end