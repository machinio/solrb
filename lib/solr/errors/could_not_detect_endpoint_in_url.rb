module Solr
  module Errors
    class CouldNotDetectEndpointInUrl < StandardError
      MESSAGE = '
        TODO: Add message

      '.freeze

      def initialize
        super(MESSAGE)
      end
    end
  end
end
