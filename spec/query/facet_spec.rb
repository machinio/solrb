RSpec.describe Solr::Query::Request::Facet do
  describe '.to_solr_h' do
    let(:value) { nil }
    let(:options) { {} }
    subject { Solr::Query::Request::Facet.new(type: type, field: field, value: value, options: options).to_solr_h }

    context 'when type is "terms"' do
      let(:result) do
        {
          field_1: {
            type: :terms,
            field: 'field_1',
            limit: 10
          }
        }
      end

      let(:type) { :terms }
      let(:field) { :field_1 }
      let(:options) { { limit: 10 } }

      it { is_expected.to eq(result) }
    end

    context 'when type is "query"' do
      let(:result) do
        {
          'field_1' => 'percentile(field_2, 5)'
        }
      end

      let(:type) { :query }
      let(:field) { :field_1 }
      let(:value) { 'percentile(field_2, 5)' }

      it { is_expected.to eq(result) }
    end

    context 'when type is "range"' do
      let(:result) do
        {
          field_1: {
            type: :range,
            field: 'field_1',
            limit: 0,
            gap: 20,
            start: 0,
            end: 100
          }
        }
      end

      let(:type) { :range }
      let(:field) { :field_1 }
      let(:options) { { gap: 20, lower_bound: 0, upper_bound: 100 } }

      it { is_expected.to eq(result) }
    end
  end
end
