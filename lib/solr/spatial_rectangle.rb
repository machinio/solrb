module Solr
  class SpatialRectangle
    attr_reader :upper_right, :lower_left

    def initialize(upper_right:, lower_left:)
      raise ArgumentError, 'upper_right must be a Solr::SpatialPoint' unless upper_right.is_a?(Solr::SpatialPoint)
      raise ArgumentError, 'lower_left must be a Solr::SpatialPoint' unless lower_left.is_a?(Solr::SpatialPoint)

      @upper_right = upper_right
      @lower_left = lower_left
    end

    def to_solr_s
      "[#{lower_left.to_solr_s} TO #{upper_right.to_solr_s}]"
    end
  end
end
