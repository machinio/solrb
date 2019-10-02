RSpec.describe Solr::Configuration do
  subject { described_class.new }

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

  context 'specify nil url' do
    it 'raises exception' do
      expect do
        Solr.configure do |config|
          config.url = nil
        end
      end.to_not raise_error
    end
  end

  context 'don\'t specify url' do
    it 'raises exception' do
      solr_url_env = ENV['SOLR_URL']
      ENV['SOLR_URL'] = nil

      expect do
        Solr.configure do |config|
        end
      end.to raise_error(Solr::Errors::SolrUrlNotDefinedError)

      ENV['SOLR_URL'] = solr_url_env
    end
  end

  context 'set faraday_options' do
    before do
      Solr.configure do |config|
        config.faraday_options = { request: { timeout: 15, open_timeout: 10 } }
      end
    end

    let(:expected_config) do
      { headers: { user_agent: "Solrb v#{Solr::VERSION}"}, request: { timeout: 15, open_timeout: 10 } }
    end

    it 'users the set faraday_options' do
      expect(Solr.configuration.faraday_options).to eq(expected_config)
      core = Solr.configuration.default_core_config
      expect(core.url).to eq(ENV['SOLR_URL'])
    end
  end

  context 'set faraday_configuration' do
    before do
      Solr.configure do |config|
        config.faraday_configure do |f|
          f.adapter :net_http do |http|
            http.idle_timeout = 150
          end
        end
      end
    end

    it 'uses the set faraday_configuration' do
      expect(Solr.configuration.faraday_configuration).to be_a(Proc)
    end
  end

  context 'core name in ENV variable' do
    before do
      Solr.configure do |config|
        config.define_core do |f|
          f.field :description
        end
      end
    end

    it 'gets the core name from ENV config' do
      expect(Solr.configuration.cores.keys).to eq([nil])
      core = Solr.configuration.default_core_config
      expect(core.url).to eq(ENV['SOLR_URL'])
    end
  end

  context 'core name in `define_core`' do
    before do
      Solr.configure do |config|
        config.url = 'http://localhost:8983'

        config.define_core(name: :'test-core') do |f|
          f.field :description
        end
      end
    end

    it 'raises exception' do
      expect(Solr.configuration.cores.keys).to include(:'test-core')
      core = Solr.configuration.default_core_config
      expect(core.url).to eq('http://localhost:8983/test-core')
      expect(core.name).to eq(:'test-core')
    end
  end

  context 'one core' do
    before do
      Solr.configure do |config|
        config.define_core(name: :'test-core') do |f|
          f.field :description
          f.field :title, dynamic_field: :text
          f.field :tags, solr_name: :tags_array
          f.dynamic_field :text, solr_name: '*_text'
        end
      end
    end

    context 'configure fields' do
      it 'sets fields' do
        expect(Solr.configuration.cores.values.first.fields).to include(:description, :title, :tags)
      end
    end

    context 'use dynamic_field option without dynamic field configuration' do
      it 'raises error' do
        expect do
          Solr.configure do |config|
            config.define_core(name: :'test-core') do |f|
              f.field :title, dynamic_field: :text
            end
          end
        end.to raise_error("Field 'title' is mapped to an undefined dynamic field 'text'")
      end
    end
  end

  context 'multiple cores' do
    before do
      Solr.configure do |config|
        config.define_core(name: :'test-core') do |f|
          f.field :description
          f.field :title, dynamic_field: :text
          f.field :tags, solr_name: :tags_array
          f.dynamic_field :text, solr_name: '*_text'
        end

        config.define_core(name: :'test-core-2') do |f|
          f.field :model
          f.field :manufacturer, dynamic_field: :text
          f.dynamic_field :text, solr_name: '*_text'
        end
      end
    end

    context 'configure fields' do
      it 'sets fields' do
        expect(Solr.configuration.cores[:'test-core'].fields).to include(:description, :title, :tags)
        expect(Solr.configuration.cores[:'test-core-2'].fields).to include(:model, :manufacturer)
      end
    end

    context 'use dynamic_field option without dynamic field configuration' do
      it 'raises error' do
        expect do
          Solr.configure do |config|
            config.define_core(name: :'test-core') do |f|
              f.field :title, dynamic_field: :text
            end
          end
        end.to raise_error("Field 'title' is mapped to an undefined dynamic field 'text'")
      end
    end

    context 'multiple cores without names' do
      it 'raises error' do
        expect do
          Solr.configure do |config|
            config.define_core do |f|
              f.field :title
            end

            config.define_core do |f|
              f.field :model
            end
          end
        end.to raise_error("A core with name '' has been already defined")
      end
    end
  end

  context 'set master url and slave url, disable_read_from_master on config block' do
    let(:master_url) { 'http://localhost:8983/solr/' }
    let(:slave_url) { 'http://localhost:8984/solr/' }

    before do
      Solr.configure do |config|
        config.master_url = master_url
        config.slave_url = slave_url
        config.disable_read_from_master = true
      end
    end

    it 'uses the settings' do
      expect(Solr.configuration.master_url).to eq(master_url)
      expect(Solr.configuration.slave_url).to eq(slave_url)
      expect(Solr.configuration.disable_read_from_master).to eq(true)
    end
  end
end
