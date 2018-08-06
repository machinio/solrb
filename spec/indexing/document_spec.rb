RSpec.describe Solr::Indexing::Document do
  it 'initializes empty document' do
    doc = described_class.new
    expect(doc.fields).to be_empty
  end

  it 'initializes document from fields hash' do
    doc = described_class.new(id: 5, name: 'Chicago')
    expect(doc.fields).to eq({id: 5, name: 'Chicago'})
  end

  it 'uses add_field to add fileds one by one' do
    doc = described_class.new
    doc.add_field(:id, 6)
    doc.add_field(:name, 'Milwaukee')
    expect(doc.fields).to eq({id: 6, name: 'Milwaukee'})
  end
end