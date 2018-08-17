RSpec.describe Solr::Delete::Request do
  before do
    Solr.delete_by_query('*:*', commit: true, core_name: :'test-core')
    doc = Solr::Indexing::Document.new(id: 1, name_txt_en: 'Solrb')
    Solr::Indexing::Request.new(core_name: :'test-core', documents: [doc]).run(commit: true)
  end

  it 'deletes by id' do
    req = Solr::Delete::Request.new(core_name: :'test-core', id: 1)
    response = req.run(commit: true)
    expect(response.status).to eq 'OK'
  end

  it 'deletes by query' do
    req = Solr::Delete::Request.new(core_name: :'test-core', query: '*:*')
    response = req.run(commit: true)
    expect(response.status).to eq 'OK'
  end

  it 'deletes by id using short-hand syntax' do
    response = Solr.delete_by_id(1, core_name: :'test-core', commit: true)
    expect(response.status).to eq 'OK'
  end

  it 'deletes by query using short-hand syntax' do
    response = Solr.delete_by_query('*:*', core_name: :'test-core', commit: true)
    expect(response.status).to eq 'OK'
  end
end
