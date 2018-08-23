module Solr
  module Query
    class Request
      class Boosting
        class TextualFieldValueMatchBoostFunction < FieldValueMatchBoostFunction
          def to_solr_s(core:)
            "if(termfreq(#{solr_field(core: core)},'#{value}'),#{boost_magnitude},1)"
          end
        end
      end
    end
  end
end
