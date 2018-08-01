module Solr
  class FieldType
    attr_reader :name, :field_suffix

    def initialize(name, field_suffix: '')
      @name = name
      @field_suffix = field_suffix
      freeze
    end
  end
end
