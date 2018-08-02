require 'solr/field'
require 'solr/dynamic_field_type'
require 'solr/field_definition_builder'
require 'solr/type_definition_builder'

module Solr
  class Configuration
    attr_accessor :open_timeout, :read_timeout, :url, :field_types, :fields

    def initialize
      @read_timeout = 2
      @open_timeout = 8
      @url = ''
      @field_types = {}
      @fields = {}
    end

    def uri
      @uri ||= URI.parse(url)
    end

    def define_field_types
      builder = Solr::TypeDefinitionBuilder.new
      yield builder
      field_types.merge!(builder.build)
    end

    def define_fields
      builder = Solr::FieldDefinitionBuilder.new(field_types)
      yield builder
      fields.merge!(builder.build)
    end
  end
end
