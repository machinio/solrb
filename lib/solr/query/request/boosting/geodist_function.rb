# Spatial search:
# https://cwiki.apache.org/confluence/display/solr/Spatial+Search

module Solr
  module Query
    class Request
      class Boosting
        class GeodistFunction
          include Solr::Support::SchemaHelper

          attr_reader :field, :latitude, :longitude

          def initialize(field:, latitude:, longitude:)
            @field = field
            @latitude = latitude
            @longitude = longitude
            freeze
          end

          def to_solr_s(core:)
            # this constants are magical, but they influence the slope of geo proximity decay function
            'recip(geodist(),3,17000,3000)'
          end

          # TODO: Check this dead code and the initialize arguments
          def latlng
            "#{latitude},#{longitude}"
          end

          def sfield(core:)
            solarize_field(core: core, field: field)
          end
        end
      end
    end
  end
end
