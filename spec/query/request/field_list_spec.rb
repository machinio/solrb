RSpec.describe Solr::Query::Request::FieldList do
  describe '.to_solr_s' do
    let(:fields) { %i(name title) }

    subject { described_class.new(fields: fields).to_solr_s }

    it { is_expected.to eq('id,name,title') }
  end
end
