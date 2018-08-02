RSpec.describe Solr::Indexing do
  it 'indexes a single document' do
    doc = Solr::Indexing::Document.new(id: 994, name: 'Solrb')
    req = Solr::Indexing::Request.new([doc])
    resp = req.run(commit: true)
    expect(resp.status).to eq :OK
  end

  it 'indexes multiple documents' do
    doc1 = Solr::Indexing::Document.new(id: 995, name: 'Curitiba')
    doc2 = Solr::Indexing::Document.new(id: 996, name: 'Kislovodsk')
    req = Solr::Indexing::Request.new([doc1, doc2])
    resp = req.run(commit: true)
    expect(resp.status).to eq :OK
  end
end