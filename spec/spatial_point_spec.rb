RSpec.describe Solr::SpatialPoint do
  describe '#to_solr_s' do
    it 'returns a solr string' do
      expect(described_class.new(lat: 1.0, lng: 2.0).to_solr_s).to eq('1.0,2.0')
    end
  end
end
