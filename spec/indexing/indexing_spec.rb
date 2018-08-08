RSpec.describe Solr::Indexing do
  it 'indexes a single document' do
    doc = Solr::Indexing::Document.new(id: 994, name: 'Solrb')
    req = Solr::Indexing::Request.new([doc])
    resp = req.run(commit: true)
    expect(resp.status).to eq 'OK'
  end

  it 'indexes multiple documents' do
    doc1 = Solr::Indexing::Document.new(id: 995, name: 'Curitiba')
    doc2 = Solr::Indexing::Document.new(id: 996, name: 'Kislovodsk')
    req = Solr::Indexing::Request.new([doc1, doc2])
    resp = req.run(commit: true)
    expect(resp.status).to eq 'OK'
  end

  context 'with configuration' do
    it 'indexes with dynamic field configuration' do
      Solr.configure do |config|
        config.define_fields do |f|
          f.field :title, dynamic_field: :text_en
          f.dynamic_field :text_en, solr_name: '*_txt_en'
        end
      end
      doc1 = Solr::Indexing::Document.new(id: 10, title: 'iPhone X')
      req = Solr::Indexing::Request.new([doc1])
      resp = req.run(commit: true)
      expect(resp.status).to eq 'OK'
      # return default configuration
      Solr.configuration = Solr:: Configuration.new
    end
  end
end