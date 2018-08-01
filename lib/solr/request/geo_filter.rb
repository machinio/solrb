module Solr
  class Request
    class GeoFilter
      SPATIAL_RADIUS = 161 # roughly 100mi

      include Solr::SchemaHelper

      attr_reader :field, :latitude, :longitude

      def initialize(field:, latitude:, longitude:)
        @field = field
        @latitude = latitude
        @longitude = longitude
        freeze
      end

      def to_solr_s
        solr_field = solarize_field(@field)
        # TODO this should be configurable
        "{!geofilt sfield=#{solr_field} pt=#{@latitude},#{@longitude} d=#{SPATIAL_RADIUS}}"
      end
    end
  end
end
