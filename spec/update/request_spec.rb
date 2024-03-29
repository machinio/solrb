RSpec.describe Solr::Update::Request do
  context 'without configuration' do
    it 'adds a single document' do
      command = Solr::Update::Commands::Add.new(doc: { id: '1' })

      expect(Solr::Request::HttpRequest).to receive(:new).
        with(hash_including(body: { 'add' => [command] })).
        and_call_original

      req = Solr::Update::Request.new([command])
      resp = req.run
      expect(resp.status).to eq 'OK'
    end

    it 'adds a multiple documents' do
      commands = [
        Solr::Update::Commands::Add.new(doc: { id: '1' }),
        Solr::Update::Commands::Add.new(doc: { id: '2' })
      ]

      expect(Solr::Request::HttpRequest).to receive(:new).
        with(hash_including(body: { 'add' => commands })).
        and_call_original

      req = Solr::Update::Request.new(commands)
      resp = req.run
      expect(resp.status).to eq 'OK'
    end

    it 'adds and deletes documents' do
      add_command = Solr::Update::Commands::Add.new(doc: { id: '1' })
      delete_command = Solr::Update::Commands::Delete.new(id: '2')

      expect(Solr::Request::HttpRequest).to receive(:new).
        with(hash_including(body: { 'add' => [add_command], 'delete' => delete_command })).
        and_call_original

      req = Solr::Update::Request.new([add_command, delete_command])
      resp = req.run
      expect(resp.status).to eq 'OK'
    end

    it 'deletes multiple documents by id' do
      delete_commands = [
        Solr::Update::Commands::Delete.new(id: '1'),
        Solr::Update::Commands::Delete.new(id: '2')
      ]

      expect(Solr::Request::HttpRequest).to receive(:new).
        with(hash_including(body: { 'delete' => delete_commands })).
        and_call_original

      req = Solr::Update::Request.new(delete_commands)
      resp = req.run
      expect(resp.status).to eq 'OK'
    end

    it 'deletes multiple documents by id and filters' do
      filters = [
        Solr::Query::Request::Filter.new(type: :equal, field: :name_txt_en, value: 'Solrb')
      ]

      delete_commands = [
        Solr::Update::Commands::Delete.new(id: '1'),
        Solr::Update::Commands::Delete.new(filters: filters)
      ]

      expect(Solr::Request::HttpRequest).to receive(:new).
        with(hash_including(body: { 'delete' => delete_commands })).
        and_call_original

      req = Solr::Update::Request.new(delete_commands)
      resp = req.run
      expect(resp.status).to eq 'OK'
    end
  end
end
