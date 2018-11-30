module Solr
  module Query
    class Request
      class Sorting
        class Function
          attr_reader :function
          
          def initialize(function:)
            @function = function
            freeze
          end

          def to_solr_s
            function
          end
        end
      end
    end
  end
end
