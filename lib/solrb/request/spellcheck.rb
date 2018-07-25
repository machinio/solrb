module Solr
  class Request
    class Spellcheck
      class Disabled
        attr_reader :previous_search_term, :collationed_search_term

        def initialize(previous_search_term: nil, collationed_search_term: nil)
          @previous_search_term = previous_search_term
          @collationed_search_term = collationed_search_term
        end

        def to_h
          {}
        end

        def collationed?
          collationed_search_term.present?
        end

        def disabled?
          true
        end

        def inspect
          'Disabled'
        end
      end

      class Default
        def to_h
          {
            spellcheck: true,
            'spellcheck.dictionary': 'spellcheck',
            'spellcheck.count': 1,
            'spellcheck.collate': true,
            'spellcheck.maxCollations': 1,
            'spellcheck.collateExtendedResults': true,
            'spellcheck.maxCollationTries': 1,
            'spellcheck.onlyMorePopular': true
          }
        end

        def previous_search_term
        end

        def collationed_search_term
        end

        def collationed?
          false
        end

        def disabled?
          false
        end
      end

      # TODO CHECK THE NAMING
      def self.collationed(previous:, collationed:)
        Disabled.new(
          previous_search_term: previous,
          collationed_search_term: collationed
        )
      end

      def self.disabled
        Disabled.new
      end

      def self.default
        Default.new
      end
    end
  end
end
