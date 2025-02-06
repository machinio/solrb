RSpec.describe Solr::MasterSlave::Configuration do
  subject { described_class.new }

  context 'uses urls' do
    let(:master_url) { 'http://localhost:8983/solr/' }
    let(:slave_url) { 'http://localhost:8984/solr/' }

    it 'returns active nodes' do
      subject.master_url = master_url
      subject.slave_url = slave_url
      expect(subject.active_nodes_for(collection: :test_core)).to eq([master_url, slave_url])
    end
  end
end
