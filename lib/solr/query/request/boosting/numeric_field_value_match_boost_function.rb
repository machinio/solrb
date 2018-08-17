module Solr
  module Query
    class Request
      class Boosting
        class NumericFieldValueMatchBoostFunction < FieldValueMatchBoostFunction
          def to_solr_s(core_name:)
            "if(sub(def(#{solr_field(core_name: core_name)},-1),#{value}),1,#{boost_magnitude})"
          end
        end
      end
    end
  end
end
