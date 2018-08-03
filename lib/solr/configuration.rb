require 'solr/field_configuration/field'
require 'solr/field_configuration/dynamic_field_type'
require 'solr/field_configuration/field_definition_builder'
require 'solr/field_configuration/type_definition_builder'

module Solr
  class Configuration
    attr_accessor :faraday_options, :url, :field_types, :fields, :test_connection

    def initialize
      @faraday_options = { request: { timeout: 2, open_timeout: 8 } }
      @url = ENV['SOLR_URL']
      @field_types = {}
      @fields = {}
    end

    def uri
      @uri ||= URI.parse(url)
    end

    def define_field_types
      builder = Solr::FieldConfiguration::TypeDefinitionBuilder.new
      yield builder
      field_types.merge!(builder.build)
    end

    def define_fields
      builder = Solr::FieldConfiguration::FieldDefinitionBuilder.new(field_types)
      yield builder
      fields.merge!(builder.build)
    end
  end
end
