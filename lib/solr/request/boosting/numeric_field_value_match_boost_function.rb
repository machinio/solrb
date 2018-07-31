module Solr
  class Request
    class Boosting
      class NumericFieldValueMatchBoostFunction < FieldValueMatchBoostFunction
        def to_solr_s
          "if(sub(def(#{solr_field},-1),#{value}),1,#{boost_magnitude})"
        end
      end
    end
  end
end
