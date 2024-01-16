module Solr
  class SpatialPoint
    attr_reader :lat, :long

    def initialize(lat:, long:)
      @lat = lat
      @long = long
    end

    def to_solr_s
      "#{lat},#{long}"
    end
  end
end
