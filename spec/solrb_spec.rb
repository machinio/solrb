RSpec.describe Solr do
  it 'has a version number' do
    expect(Solr::VERSION).not_to be nil
  end

  describe '.current_core_config' do
    it 'uses default url' do
      expect(Solr.current_core_config.url).to eq(ENV['SOLR_URL'])
    end
  end

  describe '.with_core' do
    it 'uses passed core' do
      Solr.with_core(:'some-core') do
        expect(Solr.current_core_config.name).to eq(:'some-core')
      end
    end

    describe 'uses specified core' do
      before do
        Solr.configure do |config|
          config.url = 'http://localhost:8983'

          config.define_core(name: :'test-core-1', default: true) do |f|
            f.field :description
          end

          config.define_core(name: :'test-core-3') do |f|
            f.field :description
          end
        end
      end

      specify do
        Solr.with_core(:'some-core-3') do
          expect(Solr.current_core_config.name).to eq(:'some-core-3')
        end
      end
    end
  end
end
