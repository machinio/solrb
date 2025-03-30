RSpec.describe Solr::SpatialRectangle do
  describe '#to_solr_s' do
    it 'returns a solr string' do
      expect(described_class.new(
        top_right: Solr::SpatialPoint.new(lat: 1.0, lon: 2.0),
        bottom_left: Solr::SpatialPoint.new(lat: 3.0, lon: 4.0)
      ).to_solr_s).to eq('[3.0,4.0 TO 1.0,2.0]')
    end
  end
end
