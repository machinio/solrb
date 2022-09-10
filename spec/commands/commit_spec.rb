RSpec.describe 'Solr::Commands - Commit' do
  let(:id) { 1092 } # any random number

  it 'commits pending changes' do
    Solr.delete_by_id(id, commit: true)
    indexing_doc = Solr::Update::Commands::Add.new(doc: { id: id, name_txt_en: 'Pending' })
    indexing_request = Solr::Update::Request.new([indexing_doc])
    indexing_request.run

    filter = Solr::Query::Request::Filter.new(type: :equal, field: :id, value: id)
    query_request = Solr::Query::Request.new(search_term: '*:*', filters: [filter])
    query_response = query_request.run(page: 1, rows: 0)
    expect(query_response).to be_empty

    Solr.commit

    query_response = query_request.run(page: 1, rows: 0)
    expect(query_response.total_count).to eq 1
  end
end
