RSpec.describe Solr::Request::Runner do
  let(:solr_response_body) do
    '{"responseHeader":{"status":0,"QTime":0,"params":{}},"response":{"numFound":0,"start":0,"docs":[]}}'
  end
  let(:solr_response) { double(:solr_response, status: 200, body: solr_response_body, reason_phrase: 'OK') }
  let(:solr_connection) { double(:solr_connection, call: solr_response) }
  let(:request_body) { '{ "some_json_key": "some_json_value" }' }
  let(:request) { double(:request, path: '/select', method: :get, body: request_body, url_params: {}) }

  subject { described_class.new(request: request, solr_connection: solr_connection) }

  describe '.call' do
    it 'calls solr connection' do
      expect(solr_connection).to receive(:call).with(url: 'http://localhost:8983/solr/test-core/select',
                                                     method: :get,
                                                     body: '{ "some_json_key": "some_json_value" }')
      subject.call
    end

    it 'returns a parsed response' do
      response = subject.call
      expect(response.body).to eq({ "responseHeader" => { "status" => 0, "QTime" => 0, "params" => {} },
                                     "response" => { "numFound" => 0, "start" => 0, "docs" => [] } })
      expect(response.class).to eq(Solr::Response)
    end

    context 'multiple urls' do
      let(:node_selection_strategy) do
        double(:node_selection_strategy, call: ['http://node1:8983/test-core', 'http://node2:8983/test-core'])
      end

      before do
        allow(Solr).to receive(:cloud_enabled?).and_return(true)
      end

      subject { described_class.new(request: request,
                                    node_selection_strategy: node_selection_strategy,
                                    solr_connection: solr_connection) }

      it 'sends the request to first url' do
        expect(solr_connection).to receive(:call).with(url: 'http://node1:8983/test-core/select',
                                                       method: :get,
                                                       body: '{ "some_json_key": "some_json_value" }')
        subject.call
      end

      it 'fails if any of the urls respond' do
        allow(solr_connection).to receive(:call).and_raise(Faraday::ConnectionFailed.new(''))
        expect { subject.call }.to raise_error(Solr::Errors::SolrConnectionFailedError)
      end
    end

    context 'no urls' do
      let(:node_selection_strategy) { double(:node_selection_strategy, call: []) }

      before do
        allow(Solr).to receive(:cloud_enabled?).and_return(true)
      end

      subject { described_class.new(request: request, node_selection_strategy: node_selection_strategy) }

      it 'fails' do
        expect { subject.call }.to raise_error(Solr::Errors::NoActiveSolrNodesError)
      end
    end

    context 'override url set' do
      let(:url) { 'http://override:8983/solr' }

      it 'calls solr connection' do
        Solr.with_node_url(url) do
          Solr.with_core(:fakecore) do
            expect(solr_connection).to receive(:call).with(url: 'http://override:8983/solr/fakecore/select',
                                                          method: :get,
                                                          body: '{ "some_json_key": "some_json_value" }')
            subject.call
          end
        end
      end
    end
  end
end
