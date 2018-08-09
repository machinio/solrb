RSpec.describe Solr::Configuration do
  subject { described_class.new }

  after(:each) do
    # Reset configuration
    Solr.configuration = Solr::Configuration.new
  end

  context 'default url' do
    it 'uses default url' do
      expect(Solr.configuration.url).to eq(ENV['SOLR_URL'])
    end
  end

  context 'set url on config block' do
    before do
      Solr.configure do |config|
        config.url = 'http://localhost:8983/solr/core'
      end
    end

    it 'uses the set url' do
      expect(Solr.configuration.url).to eq('http://localhost:8983/solr/core')
    end
  end

  context 'no url' do
    before do
      Solr.configure do |config|
        config.url = nil
      end
    end

    it 'raises exception' do
      expect { Solr.configuration.url }.to raise_error(Errors::SolrUrlNotDefinedError)
    end
  end

  context 'set faraday_options' do
    before do
      Solr.configure do |config|
        config.faraday_options = { request: { timeout: 15 } }
      end
    end

    it 'users the set faraday_options' do
      expect(Solr.configuration.faraday_options).to eq(request: { timeout: 15 })
    end
  end

  context 'fields' do
    before do
      Solr.configure do |config|
        config.define_fields do |f|
          f.field :description
          f.field :title, dynamic_field: :text
          f.field :tags, solr_name: :tags_array
          f.dynamic_field :text, solr_name: '*_text'
        end
      end
    end

    context 'configure fields' do
      it 'sets fields' do
        expect(Solr.configuration.fields.keys).to include(:description, :title, :tags)
      end
    end

    context 'use dynamic_field option without dynamic field configuration' do
      it 'raises error' do
        expect do
          Solr.configure do |config|
            config.define_fields do |f|
              f.field :title, dynamic_field: :text
            end
          end
        end.to raise_error("Field 'title' is mapped to an undefined dynamic field 'text'")
      end
    end
  end
end
