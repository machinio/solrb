RSpec.describe Solr::Query::Request::Filter do
  describe '.to_solr_s' do
    context 'when type is not equal' do
      subject { described_class.new(type: :not_equal, field: :field, value: 'value').to_solr_s(core: :'test-core') }
      it { is_expected.to eq('-field:("value")') }
    end

    context 'when value is array' do
      subject { described_class.new(type: :equal, field: :field, value: [1, 2, 3]).to_solr_s(core: :'test-core') }
      it { is_expected.to eq('field:("1" OR "2" OR "3")') }
    end

    context 'when value is range' do
      subject { described_class.new(type: :equal, field: :field, value: 1..100).to_solr_s(core: :'test-core') }
      it { is_expected.to eq('field:(["1" TO "100"])') }

      context 'when max is infinity' do
        subject { described_class.new(type: :equal, field: :field, value: 1..Float::INFINITY).to_solr_s(core: :'test-core') }
        it { is_expected.to eq('field:(["1" TO *])') }
      end
    end

    context 'when value is date' do
      subject { described_class.new(type: :equal, field: :field, value: Date.parse('2018-08-01')).to_solr_s(core: :'test-core') }
      it { is_expected.to eq('field:(2018-08-01T00:00:00Z)') }
    end

    context 'when value is string' do
      subject { described_class.new(type: :equal, field: :field, value: 'value').to_solr_s(core: :'test-core') }
      it { is_expected.to eq('field:("value")') }
    end
  end
end
