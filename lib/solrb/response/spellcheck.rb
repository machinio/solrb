module Solr
  class Response
    class Spellcheck
      attr_reader :response

      class Collation
        def initialize(data)
          @data = data
        end

        def collation_query
          @data['collationQuery']
        end

        def hits
          @data['hits']
        end

        def misspellings_and_corrections
          return {} unless @data['misspellingsAndCorrections']
          @data['misspellingsAndCorrections'].in_groups_of(2).to_h
        end
      end

      def self.empty
        new({})
      end

      def initialize(response)
        @response = response || {}
      end

      def collations
        Array(response['collations']).flatten(1).in_groups_of(2).map do |_, collation|
          Collation.new(collation)
        end
      end
    end
  end
end
