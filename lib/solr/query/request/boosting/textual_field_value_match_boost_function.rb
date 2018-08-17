module Solr
  module Query
    class Request
      class Boosting
        class TextualFieldValueMatchBoostFunction < FieldValueMatchBoostFunction
          def to_solr_s(core_name:)
            "if(termfreq(#{solr_field(core_name: core_name)},'#{value}'),#{boost_magnitude},1)"
          end
        end
      end
    end
  end
end
