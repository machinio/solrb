module Solr
  class Field
    attr_reader :name, :field_type, :dynamic_field_name_mapping

    def initialize(name:, field_type:, dynamic_field_name_mapping: true)
      @name = name
      @field_type = field_type
      @dynamic_field_name_mapping = dynamic_field_name_mapping
    end

    def solr_field_name
      if field_type.dynamic? && dynamic_field_name_mapping
        field_type.solr_definition.gsub('*', name.to_s)
      else
        name.to_s
      end
    end
  end
end
