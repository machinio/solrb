RSpec.describe Solr::Query::Request::AndFilter do
  describe '.to_solr_s' do
    let(:filters) do
      [
        Solr::Query::Request::Filter.new(type: :not_equal, field: :field, value: 'value'),
        Solr::Query::Request::Filter.new(type: :equal, field: :field, value: 1..100)
      ]
    end

    subject { described_class.new(*filters).to_solr_s }

    it { is_expected.to eq('(-field:("value") AND field:(["1" TO "100"]))') }
  end
end
