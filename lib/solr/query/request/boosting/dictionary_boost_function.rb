module Solr
  module Query
    class Request
      class Boosting
        class DictionaryBoostFunction
          include Solr::Support::SchemaHelper
          using Solr::Support::StringExtensions
          attr_reader :field, :dictionary, :default_boost

          def initialize(field:, dictionary:, default_boost: 1)
            raise 'dictionary must be a non-empty Hash' if Hash(dictionary).empty?
            @field = field
            @dictionary = dictionary
            @default_boost = default_boost
          end

          # example: given a hash (dictionary)
          # {3025 => 2.0, 3024 => 1.5, 3023 => 1.2}
          # and a field of category_id
          # the resulting boosting function will be:
          # if(eq(category_id_it, 3025), 2.0, if(eq(category_id_it, 3024), 1.5, if(eq(category_id_it, 3023), 1.2, 1)))
          # note that I added spaces for readability, real Solr query functions must always be w/out spaces
          def to_solr_s
            sf = solarize_field(field)
            dictionary.to_a.reverse.reduce(default_boost) do |acc, (field_value, boost)|
              if field_value.is_a?(String) || field_value.is_a?(Symbol)
                "if(termfreq(#{sf},\"#{field_value.to_s.solr_escape}\"),#{boost},#{acc})"
              else
                "if(eq(#{sf},#{field_value}),#{boost},#{acc})"
              end
            end
          end
        end
      end
    end
  end
end
