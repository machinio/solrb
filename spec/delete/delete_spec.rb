RSpec.describe Solr::Delete::Request do
  before do
    Solr.delete_by_query('*:*', commit: true)
    doc = Solr::Indexing::Document.new(id: 1, name_txt_en: 'Solrb')
    Solr::Indexing::Request.new([doc]).run(commit: true)
  end

  it 'deletes by id' do
    req = Solr::Delete::Request.new(id: 1)
    response = req.run(commit: true)
    expect(response.status).to eq 'OK'
  end

  it 'deletes by query' do
    req = Solr::Delete::Request.new(query: '*:*')
    response = req.run(commit: true)
    expect(response.status).to eq 'OK'
  end

  it 'deletes by id using short-hand syntax' do
    response = Solr.delete_by_id(1, commit: true)
    expect(response.status).to eq 'OK'
  end

  it 'deletes by query using short-hand syntax' do
    response = Solr.delete_by_query('*:*', commit: true)
    expect(response.status).to eq 'OK'
  end
end
