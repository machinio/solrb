module Solr
  module Errors
    class CouldNotInferImplicitCoreName < StandardError
      MESSAGE = '
        TODO: Add message

      '.freeze

      def initialize
        super(MESSAGE)
      end
    end
  end
end

