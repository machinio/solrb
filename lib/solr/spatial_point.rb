module Solr
  class SpatialPoint
    attr_reader :lat, :lon

    def initialize(lat:, lon:)
      @lat = lat
      @lon = lon
    end

    def to_solr_s
      "#{lat},#{lon}"
    end
  end
end
