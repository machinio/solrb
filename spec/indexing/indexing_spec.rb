RSpec.describe Solr::Indexing do
  it 'accepts a single document for indexing' do
    doc = Solr::Indexing::Document.new
    doc.add_field(:id, 994)
    doc.add_field(:name, 'Solrb')
    req = Solr::Indexing::Request.new([doc], commit: true)
    resp = req.run
    expect(resp.status).to eq :OK
  end
end