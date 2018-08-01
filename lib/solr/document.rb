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

    attr_reader :id, :model_name, :score, :debug_info, :group

    def initialize(id:, model_name:, score: nil, debug_info: nil, group: GroupInformation.empty)
      @id = id
      @model_name = model_name
      @score = score
      @debug_info = debug_info
      @group = group
    end
  end
end
