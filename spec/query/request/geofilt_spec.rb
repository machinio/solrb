RSpec.describe Solr::Query::Request::Geofilt do
  describe '.to_solr_s' do
    let(:spatial_point) { Solr::SpatialPoint.new(latitude: -25.429692, longitude: -49.271265) }

    subject { described_class.new(field: :machine_type, spatial_point: spatial_point, spatial_radius: 161) }

    it { expect(subject.to_solr_s).to eq('{!geofilt sfield=machine_type pt=-25.429692,-49.271265 d=161}') }
  end
end
