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

  it 'deteles by filters' do
    filters = [
      Solr::Query::Request::Filter.new(type: :equal, field: :id, value: 1),
      Solr::Query::Request::Filter.new(type: :equal, field: :name_txt_en, value: 'Solrb')
    ]

    commit_command = Solr::Update::Commands::Commit.new
    delete_command = Solr::Update::Commands::Delete.new(filters: filters)
    commands = [commit_command, delete_command]

    expect(Solr::Request::HttpRequest).to receive(:new).
      with(hash_including(body: { 'delete' => delete_command, 'commit' => commit_command })).
      and_call_original

    request = Solr::Update::Request.new(commands)
    response = request.run

    expect(response.status).to eq 'OK'
  end
end
