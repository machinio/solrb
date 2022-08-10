require 'solr/query/request/shards_preferences/property'

module Solr
  module Query
    class Request
      class ShardsPreference
        attr_accessor :properties

        def self.none
          new
        end

        def initialize(properties: [])
          @properties = properties
        end

        def empty?
          properties.empty?
        end

        def to_solr_s
          properties.map(&:to_solr_s).join(',')
        end
      end
    end
  end
end
