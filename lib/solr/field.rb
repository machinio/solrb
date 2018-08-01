module Solr
  class Field
    attr_reader :name, :type, :omit_suffix

    def initialize(name:, type:, omit_suffix: false)
      @name = name
      @type = type
      @omit_suffix = omit_suffix
    end

    def solr_field_name
      return name if omit_suffix
      "#{name}#{type.field_suffix}"
    end
  end
end
