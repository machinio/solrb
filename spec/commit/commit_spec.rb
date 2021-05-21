RSpec.describe Solr::Commit::Request do
  let(:id) { 1092 } # any random number
  it 'commits pending changes' do
    Solr.delete_by_id(id, commit: true)
    indexing_doc = Solr::Indexing::Document.new(id: id, name_txt_en: 'Pending')
    indexing_request = Solr::Indexing::Request.new([indexing_doc])
    indexing_request.run(commit: false)
    filter = Solr::Query::Request::Filter.new(type: :equal, field: :id, value: id)
    query_request = Solr::Query::Request.new(search_term: '*:*', filters: [filter])
    query_response = query_request.run(page: 1, rows: 0)
    expect(query_response).to be_empty
    Solr.commit
    query_response = query_request.run(page: 1, rows: 0)
    expect(query_response.total_count).to eq 1
  end
end
