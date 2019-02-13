module Solr
  module Errors
    class AmbiguousCoreError < StandardError
      ERROR_MESSAGE = 'Multiple cores defined: default core can\'t be found'.freeze

      def initialize
        super(ERROR_MESSAGE)
      end
    end
  end
end
