module Solr
  module Query
    class Request
      class Boosting
        # https://wiki.apache.org/solr/ExtendedDisMax#pf_.28Phrase_Fields.29
        # solr in action chapter 16.3.5
        # we only need to do the phrase proximity boosting if we have a phrase, i.e. more than 1 word
        class PhraseProximityBoost
          include Solr::SchemaHelper

          attr_reader :field, :boost_magnitude

          def initialize(field:, boost_magnitude:)
            @field = field
            @boost_magnitude = boost_magnitude
            freeze
          end

          def to_solr_s
            solr_field = solarize_field(field)
            "#{solr_field}^#{boost_magnitude}"
          end
        end
      end
    end
  end
end
