RSpec.describe Solr::Query::Request::QueryField do
  describe '.to_solr_s' do
    context 'when boost magnitude is not specified' do
      subject { described_class.new(field: :field).to_solr_s }

      it { is_expected.to eq('field^1') }
    end

    context 'when boost magnitude is specified' do
      subject { described_class.new(field: :field, boost_magnitude: 5).to_solr_s }

      it { is_expected.to eq('field^5') }
    end

    context 'with dynamic field' do
      before do
        Solr.configure do |config|
          config.define_core(name: :'test-core') do |f|
            f.field :title, dynamic_field: :text
            f.dynamic_field :text, solr_name: '*_text'
          end
        end
      end

      subject { described_class.new(field: :title).to_solr_s }

      it { is_expected.to eq('title_text^1') }
    end
  end
end
