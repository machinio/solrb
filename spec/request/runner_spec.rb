RSpec.describe Solr::Request::Runner do
  context 'when solr cloud is not enabled' do
    it 'uses SingleSolrInstanceRequestRouter' do
      expect(Solr::Request::SingleSolrInstanceRequestRouter).to receive(:run)
      described_class.post('/select', {})
    end
  end

  context 'when solr cloud is enabled' do
    before do
      Solr.configure do |config|
        config.zookeeper_url = 'localhost:2181'
      end
      Solr.enable_solr_cloud
    end

    it 'uses SolrCloudRequestRouter' do
      expect(Solr::Request::SolrCloudRequestRouter).to receive(:run)
      described_class.post('/select', {})
    end
  end
end