RSpec.describe Solr::Delete::Request do
  it 'deletes by id' do
    req = Solr::Delete::Request.new(id: 1)
    response = req.run
    expect(response.status).to eq :OK
  end

  it 'deletes by query' do
    req = Solr::Delete::Request.new(query: '*:*')
    response = req.run
    expect(response.status).to eq :OK
  end
end
 