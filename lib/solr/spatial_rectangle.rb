module Solr
  class SpatialRectangle
    attr_reader :top_right, :bottom_left

    def initialize(top_right:, bottom_left:)
      raise ArgumentError, 'top_right must be a Solr::SpatialPoint' unless top_right.is_a?(Solr::SpatialPoint)
      raise ArgumentError, 'bottom_left must be a Solr::SpatialPoint' unless bottom_left.is_a?(Solr::SpatialPoint)

      @top_right = top_right
      @bottom_left = bottom_left
    end

    def to_solr_s
      "[#{bottom_left.to_solr_s} TO #{top_right.to_solr_s}]"
    end
  end
end
