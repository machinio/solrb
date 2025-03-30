RSpec.describe Solr::Support::UrlHelper do
  describe '#solr_endpoint_from_url' do
    subject { Solr::Support::UrlHelper.solr_endpoint_from_url(url) }

    context 'when url ends with /solr' do
      let(:url) { 'http://localhost:8983/solr/core1' }

      it 'returns the solr endpoint' do
        expect(subject).to eq('http://localhost:8983/solr')
      end
    end

    context 'when url contains /solr and core name' do
      let(:url) { 'http://localhost:8983/solr/core1' }

      it 'returns the solr endpoint' do
        expect(subject).to eq('http://localhost:8983/solr')
      end
    end
  end

  describe '#admin_base_url_for_cores' do
    context 'when SOLR_URL is set' do
      before do
        stub_const('ENV', { 'SOLR_URL' => 'http://localhost:8983/solr/core1' })
      end

      it 'returns the admin base URL for cores' do
        expect(Solr::Support::UrlHelper.admin_base_url_for_cores).to eq('http://localhost:8983/solr')
      end
    end

    context 'when SOLR_URL and SOLR_CORE are set' do
      before do
        stub_const('ENV', { 'SOLR_URL' => 'http://localhost:8983/solr', 'SOLR_CORE' => 'core1' })
      end

      it 'returns the admin base URL for cores' do
        expect(Solr::Support::UrlHelper.admin_base_url_for_cores).to eq('http://localhost:8983/solr')
      end
    end

    context 'when url is set in configuration' do
      before do
        Solr.configure do |config|
          config.url = 'http://localhost:8983/solr/core1'
        end
      end

      it 'returns the admin base URL for cores' do
        expect(Solr::Support::UrlHelper.admin_base_url_for_cores).to eq('http://localhost:8983/solr')
      end
    end

    context 'when url and core are set in configuration' do
      before do
        Solr.configure do |config|
          config.url = 'http://localhost:8983/solr'
          config.core = 'core1'
        end
      end

      it 'returns the admin base URL for cores' do
        expect(Solr::Support::UrlHelper.admin_base_url_for_cores).to eq('http://localhost:8983/solr')
      end
    end
  end
end
