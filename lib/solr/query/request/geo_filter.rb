module Solr
  module Query
    class Request
      class GeoFilter
        SPATIAL_RADIUS = 161 # roughly 100mi

        include Solr::Support::SchemaHelper

        attr_reader :field, :latitude, :longitude, :spatial_radius

        def initialize(field:, latitude:, longitude:, spatial_radius: SPATIAL_RADIUS)
          @field = field
          @latitude = latitude
          @longitude = longitude
          @spatial_radius = spatial_radius
          freeze
        end

        def to_solr_s(core:)
          solr_field = solarize_field(core: core, field: @field)
          "{!geofilt sfield=#{solr_field} pt=#{@latitude},#{@longitude} d=#{spatial_radius}}"
        end
      end
    end
  end
end
