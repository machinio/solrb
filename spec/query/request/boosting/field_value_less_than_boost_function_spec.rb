RSpec.describe Solr::Query::Request::Boosting::FieldValueLessThanBoostFunction do
  describe '.to_solr_s' do
    subject { described_class.new(field: :machine_type, max: 10, boost_magnitude: 16) }

    it { expect(subject.to_solr_s).to eq('if(sub(10,max(machine_type,10)),1,16)') }
  end
end
