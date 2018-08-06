module Solr
  module Query
    class Request
      class Sorting
        class Field
          attr_reader :name, :direction
          def initialize(name:, direction:)
            @name = name
            @direction = direction
            freeze
          end
        end
      end
    end
  end
end
