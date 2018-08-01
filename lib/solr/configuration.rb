require 'solr/field'
require 'solr/field_type'
require 'solr/field_types'
require 'solr/entity'
require 'solr/entity_builder'

module Solr
  class Configuration
    attr_accessor :open_timeout, :read_timeout, :url, :types, :entities

    def initialize
      @read_timeout = 2
      @open_timeout = 8
      @url = ''
      @types = Solr::FieldTypes.new
      @entities = []
    end

    def uri
      @uri ||= URI.parse(url)
    end

    def define_types
      yield @types
    end

    def define_entity(name)
      builder = Solr::EntityBuilder.new(name, @types)
      yield builder
      @entities << builder.build
    end
  end
end
