module Solr
  module Query
    class Request
      class Boosting
        class TextualFieldValueMatchBoostFunction < FieldValueMatchBoostFunction
          def to_solr_s
            "if(termfreq(#{solr_field},'#{value}'),#{boost_magnitude},1)"
          end
        end
      end
    end
  end
end
