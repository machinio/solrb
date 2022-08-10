module Solr
  module Query
    class Request
      class ShardsPreferences
        class Property
          attr_reader :name, :value

          def initialize(name:, value:)
            @name = name
            @value = value
            freeze
          end

          def to_solr_s
            "#{name}:#{value}"
          end
        end
      end
    end
  end
end
