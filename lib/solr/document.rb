module Solr
  class Document
    class GroupInformation
      attr_reader :key, :value
      def initialize(key:, value:)
        @key = key
        @value = value
      end

      def self.empty
        new(key: nil, value: nil)
      end
    end

    attr_reader :id, :score, :debug_info, :group, :fields

    def initialize(id:, score: nil, debug_info: nil, group: GroupInformation.empty, fields: {})
      @id = id
      @score = score
      @debug_info = debug_info
      @group = group
      @fields = fields
    end
  end
end
