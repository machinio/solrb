# Spatial search:
# https://cwiki.apache.org/confluence/display/solr/Spatial+Search

module Solr
  module Query
    class Request
      class Boosting
        class GeodistFunction
          include Solr::Support::SchemaHelper

          attr_reader :core_name, :field, :latitude, :longitude

          def initialize(core_name:, field:, latitude:, longitude:)
            @core_name = core_name
            @field = field
            @latitude = latitude
            @longitude = longitude
            freeze
          end

          def to_solr_s
            # this constants are magical, but they influence the slope of geo proximity decay function
            'recip(geodist(),3,17000,3000)'
          end

          # TODO: Check this dead code and the initialize arguments
          def latlng
            "#{latitude},#{longitude}"
          end

          def sfield
            solarize_field(core_name: core_name, field: field)
          end
        end
      end
    end
  end
end
