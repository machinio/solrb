module Solr
  class EntityBuilder
    def initialize(entity_name, known_types)
      @entity = Solr::Entity.new(entity_name)
      @known_types = known_types
    end

    def field(name, type, opts = {})
      field_type = @known_types[type]
      raise "Field type #{type} was not defined." unless field_type

      field_options = { name: name, type: type }.merge(opts)
      field = Solr::Field.new(field_options)
      @entity.add_field(field)
    end

    def build
      @entity
    end
  end
end
