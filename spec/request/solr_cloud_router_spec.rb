RSpec.describe Solr::Request::SolrCloudRouter do
  let(:cloud_config) { double(:cloud_config) }

  before do
    allow(Solr).to receive(:cloud).and_return(cloud_config)
  end

  context 'when no solr node is available' do
    before do
      allow(cloud_config).to receive(:active_nodes_for).and_return([])
    end

    it 'raises NoActiveSolrNodesError' do
      expect { described_class.run(path: '/select',
                                   url_params: { page: 1 },
                                   request_params: { q: 'solr' },
                                   method: :post_as_json) }.to raise_error(Solr::Errors::NoActiveSolrNodesError)
    end
  end

  context 'when any solr nodes respond' do
    before do
      allow(cloud_config).to receive(:active_nodes_for).and_return(['http://localhost:4000/solr'])
    end

    it 'raises ClusterConnectionFailedError' do
      expect { described_class.run(path: '/select',
                                   url_params: { page: 1 },
                                   request_params: { q: 'solr' },
                                   method: :post_as_json) }.to raise_error(Solr::Errors::ClusterConnectionFailedError)
    end
  end

  context 'when one node is down' do
    let(:node_urls) { ['http://localhost:4000/solr', 'http://localhost:8983/solr'] }

    before do
      allow(cloud_config).to receive(:active_nodes_for).and_return(node_urls)
      allow(node_urls).to receive(:shuffle).and_return(node_urls)
    end

    it 'tries another node' do
      expect(Solr::Connection).to receive(:new) do |arg|
        expect(arg.to_s).to eq('http://localhost:4000/solr/select?page=1')
      end.and_call_original

      expect(Solr::Connection).to receive(:new) do |arg|
        expect(arg.to_s).to eq('http://localhost:8983/solr/select?page=1')
      end.and_call_original

      described_class.run(path: '/select',
                          url_params: { page: 1 },
                          request_params: { q: 'solr' },
                          method: :post_as_json)
    end
  end

  describe '.run' do
    before do
      allow(cloud_config).to receive(:active_nodes_for).and_return(['http://localhost:8983/solr'])
    end

    let(:solr_connection_instance) { double(:solr_connection_instance) }
    let(:response_body) do
      {
        'responseHeader' => { 'zkConnected' => true, 'status' => 0, 'QTime' => 186 },
        'response' => {
          'numFound' => 1,
          'start' => 0,
          'maxScore' => 1,
          'docs' => [{ 'id' => '12345' }]
        }
      }.to_json
    end
    let(:solr_response) { double(:solr_response, status: 200, body: response_body, reason_phrase: 'OK') }

    it 'sends request' do
      expect(Solr::Connection).to receive(:new) do |arg|
                                    expect(arg.to_s).to eq('http://localhost:8983/solr/select?page=1')
                                  end.and_return(solr_connection_instance)
      expect(solr_connection_instance).to receive(:post_as_json).with({ q: 'solr' }).and_return(solr_response)
      described_class.run(path: '/select',
                          url_params: { page: 1 },
                          request_params: { q: 'solr' },
                          method: :post_as_json)
    end
  end
end
