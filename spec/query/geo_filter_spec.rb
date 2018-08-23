RSpec.describe Solr::Query::Request::GeoFilter do
  describe '.to_solr_s' do
    subject { described_class.new(field: :machine_type, latitude: -25.429692, longitude: -49.271265) }

    it { expect(subject.to_solr_s(core: :'test-core')).to eq('{!geofilt sfield=machine_type pt=-25.429692,-49.271265 d=161}') }
  end
end
