RSpec.describe Solr::Indexing do
  context 'without configuration' do
    it 'indexes a single document' do
      doc = Solr::Indexing::Document.new(id: 994, name_txt_en: 'Solrb')
      req = Solr::Indexing::Request.new(core_name: :'test-core', documents: [doc])
      resp = req.run(commit: true)
      puts resp.inspect unless resp.ok?
      expect(resp.status).to eq 'OK'
    end

    it 'indexes multiple documents' do
      doc1 = Solr::Indexing::Document.new(id: 995, name_txt_en: 'Curitiba')
      doc2 = Solr::Indexing::Document.new(id: 996, name_txt_en: 'Kislovodsk')
      req = Solr::Indexing::Request.new(core_name: :'test-core', documents: [doc1, doc2])
      resp = req.run(commit: true)
      expect(resp.status).to eq 'OK'
    end
  end

  context 'with configuration' do
    before do
      Solr.configure do |config|
        config.define_core(name: :'test-core') do |f|
          f.field :name, dynamic_field: :txt_en
          f.dynamic_field :txt_en, solr_name: '*_txt_en'
        end
      end
    end

    after do
      # return default configuration
      Solr.configuration = Solr::Configuration.new
    end

    it 'indexes with dynamic field configuration' do
      doc1 = Solr::Indexing::Document.new(id: 10, name: 'iPhone X')
      req = Solr::Indexing::Request.new(core_name: :'test-core', documents: [doc1])
      resp = req.run(commit: true)
      puts resp.inspect unless resp.ok?
      expect(resp.status).to eq 'OK'
    end
  end
end
