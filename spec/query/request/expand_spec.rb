RSpec.describe Solr::Query::Request::Expand do
  describe '.to_solr_s' do
    subject { described_class.new(rows: 5) }

    it { expect(subject.to_h).to eq(expand: true, 'expand.rows': 5) }
  end
end
