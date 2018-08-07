module Solr
  module Query
    class Request
      class Sorting
        ASC = :asc
        DESC = :desc
        class None
          def initialize
            freeze
          end

          def empty?
            true
          end
        end

        attr_reader :fields

        def self.none
          None.new
        end

        def initialize(fields: [])
          @fields = fields
          freeze
        end

        def empty?
          fields.empty?
        end
      end
    end
  end
end
