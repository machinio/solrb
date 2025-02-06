RSpec.describe Solr::Query::Request do
  before do
    Solr.delete_by_query('*:*', commit: true)
    doc = Solr::Update::Commands::Add.new(doc: { id: 42, name_txt_en: 'Solrb' })
    commit = Solr::Update::Commands::Commit.new
    Solr::Update::Request.new([doc, commit]).run
  end

  after do
    Solr.delete_by_query('*:*', commit: true)
  end

  let(:search_term) { 'solrb' }
  let(:query_fields) do
    [Solr::Query::Request::QueryField.new(field: :name_txt_en)]
  end

  subject do
    Solr::Query::Request.new(search_term: search_term, query_fields: query_fields)
  end

  it 'searches' do
    response = subject.run(page: 1, page_size: 10)
    expect(response.total_count).to eq(1)
    expect(response.documents.map(&:id)).to eq(['42'])
  end
end
