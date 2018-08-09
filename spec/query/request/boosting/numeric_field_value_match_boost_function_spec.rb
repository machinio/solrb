RSpec.describe Solr::Query::Request::Boosting::NumericFieldValueMatchBoostFunction do
  describe '.to_solr_s' do
    subject { described_class.new(field: :machine_type, value: 5, boost_magnitude: 16) }

    it { expect(subject.to_solr_s).to eq('if(sub(def(machine_type,-1),5),1,16)') }
  end
end
