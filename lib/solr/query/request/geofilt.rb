module Solr
  module Query
    class Request
      class Geofilt
        include Solr::Support::SchemaHelper

        attr_reader :field, :spatial_point, :spatial_radius, :score

        def initialize(field:, spatial_point:, spatial_radius:, score: nil)
          raise ArgumentError, 'spatial_point must be a Solr::SpatialPoint' unless spatial_point.is_a?(Solr::SpatialPoint)

          @field = field
          @spatial_point = spatial_point
          @spatial_radius = spatial_radius
          @score = score
          freeze
        end

        def to_solr_s
          solr_field = solarize_field(@field)
          filter = "{!geofilt sfield=#{solr_field} pt=#{spatial_point.to_solr_s} d=#{spatial_radius}"
          filter << " score=#{score}" if score
          filter + "}"
        end
      end
    end
  end
end
