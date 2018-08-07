module Solr
  module Query
    class Request
      class Grouping
        class None
          def initialize
            freeze
          end

          def empty?
            true
          end

          def inspect
            'No Grouping'
          end
        end

        attr_reader :field, :limit

        def self.none
          None.new
        end

        def initialize(field:, limit:)
          @field = field
          @limit = limit
          freeze
        end

        def empty?
          false
        end
      end
    end
  end
end
