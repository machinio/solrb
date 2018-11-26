RSpec.describe Solr::Request::SingleSolrInstanceRouter do
  describe '.run' do
    let(:solr_connection_instance) { double(:solr_connection_instance) }
    let(:response_body) do
      {
        'responseHeader' => { 'status' => 0, 'QTime' => 186 },
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
                                    expect(arg.to_s).to eq('http://localhost:8983/solr/test-core/select?page=1')
                                  end.and_return(solr_connection_instance)
      expect(solr_connection_instance).to receive(:post_as_json).with({ q: 'solr' }).and_return(solr_response)
      described_class.run(path: '/select',
                          url_params: { page: 1 },
                          request_params: { q: 'solr' },
                          method: :post_as_json)
    end
  end
end
