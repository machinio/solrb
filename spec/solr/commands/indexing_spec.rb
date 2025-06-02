RSpec.describe 'Solr::Commands - Indexing' do
  context 'without configuration' do
    it 'indexes a single document' do
      doc = Solr::Update::Commands::Add.new(doc: { id: 994, name_txt_en: 'Solrb' })
      commit = Solr::Update::Commands::Commit.new
      req = Solr::Update::Request.new([doc, commit])
      resp = req.run
      expect(resp.status).to eq 'OK'
    end

    it 'indexes multiple documents' do
      doc1 = Solr::Update::Commands::Add.new(doc: { id: 995, name_txt_en: 'Curitiba' })
      doc2 = Solr::Update::Commands::Add.new(doc: { id: 996, name_txt_en: 'Kislovodsk' })
      commit = Solr::Update::Commands::Commit.new
      req = Solr::Update::Request.new([doc1, doc2, commit])
      resp = req.run
      expect(resp.status).to eq 'OK'
    end
  end

  context 'with configuration' do
    context 'one core' do
      before do
        Solr.configure do |config|
          config.define_core do |f|
            f.field :name, dynamic_field: :txt_en
            f.dynamic_field :txt_en, solr_name: '*_txt_en'
          end
        end
      end

      it 'indexes with dynamic field configuration' do
        doc1 = Solr::Update::Commands::Add.new(doc: { id: 10, name: 'iPhone X' })
        commit = Solr::Update::Commands::Commit.new
        req = Solr::Update::Request.new([doc1, commit])
        resp = req.run
        expect(resp.status).to eq 'OK'
      end
    end

    context 'multiple cores' do
      context 'without default core' do
        before do
          Solr.configure do |config|
            config.url = Solr::Support::UrlHelper.solr_endpoint_from_url(ENV['SOLR_URL'])

            config.define_core(name: :'test-core') do |f|
              f.field :name, dynamic_field: :txt_en
              f.dynamic_field :txt_en, solr_name: '*_txt_en'
            end

            config.define_core(name: :'test-core-2') do |f|
              f.field :name, dynamic_field: :txt_en
              f.dynamic_field :txt_en, solr_name: '*_txt_en'
            end
          end
        end

        it 'raises an error on multiple indices without explicit core param' do
          doc1 = Solr::Update::Commands::Add.new(doc: { id: 10, name: 'iPhone X' })
          commit = Solr::Update::Commands::Commit.new
          req = Solr::Update::Request.new([doc1, commit])
          expect { req.run }.to raise_error(Solr::Errors::AmbiguousCoreError)
        end

        it 'accepts explicit core param' do
          doc1 = Solr::Update::Commands::Add.new(doc: { id: 10, name: 'iPhone X' })
          commit = Solr::Update::Commands::Commit.new
          req = Solr::Update::Request.new([doc1, commit])
          resp = Solr.with_core(:'test-core') do
            req.run
          end
          expect(resp.status).to eq 'OK'
        end
      end

      context 'with default core' do
        before do
          Solr.configure do |config|
            config.url = Solr::Support::UrlHelper.solr_endpoint_from_url(ENV['SOLR_URL'])

            config.define_core(name: :'test-core', default: true) do |f|
              f.field :name, dynamic_field: :txt_en
              f.dynamic_field :txt_en, solr_name: '*_txt_en'
            end

            config.define_core(name: :'test-core-2') do |f|
              f.field :name, dynamic_field: :txt_en
              f.dynamic_field :txt_en, solr_name: '*_txt_en'
            end
          end
        end

        it 'doesn\'t rais an error on multiple indices without explicit core param' do
          doc1 = Solr::Update::Commands::Add.new(doc: { id: 10, name: 'iPhone X' })
          commit = Solr::Update::Commands::Commit.new
          req = Solr::Update::Request.new([doc1, commit])
          expect { req.run }.not_to raise_error
        end

        it 'accepts explicit core param' do
          doc1 = Solr::Update::Commands::Add.new(doc: { id: 10, name: 'iPhone X' })
          commit = Solr::Update::Commands::Commit.new
          req = Solr::Update::Request.new([doc1, commit])
          resp = req.run
          expect(resp.status).to eq 'OK'
        end
      end
    end
  end
end
