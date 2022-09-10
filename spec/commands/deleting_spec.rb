RSpec.describe 'Solr::Commands - Deleting' do
  before do
    Solr.delete_by_query('*:*', commit: true)
    doc = Solr::Update::Commands::Add.new(doc: { id: 1, name_txt_en: 'Solrb' })
    commit = Solr::Update::Commands::Commit.new
    Solr::Update::Request.new([doc, commit]).run
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
