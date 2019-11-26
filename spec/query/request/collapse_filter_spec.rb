RSpec.describe Solr::Query::Request::CollapseFilter do
  describe '.to_solr_s' do
    subject { described_class.new(field: :group_field, max: 'sum(cscore(),numeric_field)', null_policy: 'ignore') }

    it { expect(subject.to_solr_s).to eq('{!collapse field=group_field max=sum(cscore(),numeric_field) nullPolicy=ignore}') }
  end
end
