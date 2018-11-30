module Solr
  module Query
    class Request
      class Sorting
        class Field
          include Solr::Support::SchemaHelper

          attr_reader :name, :direction

          def initialize(name:, direction:)
            @name = name
            @direction = direction
            freeze
          end

          # sorting nulls last, not-nulls first
          def to_solr_s
            "exists(#{solr_field}) desc, #{solr_field} #{direction}"
          end

          def solr_field
            solarize_field(name)
          end
        end
      end
    end
  end
end
