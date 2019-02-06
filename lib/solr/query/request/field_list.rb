module Solr
  module Query
    class Request
      class FieldList
        include Solr::Support::SchemaHelper

        MANDATORY_FIELDS = %i[id].freeze

        attr_accessor :fields

        def initialize(fields: [])
          @fields = fields
        end

        def empty?
          fields.empty?
        end

        def to_solr_s
          (MANDATORY_FIELDS + fields.map(&method(:solarize_field))).uniq.join(',')
        end
      end
    end
  end
end
