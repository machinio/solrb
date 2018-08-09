RSpec.describe Solr::Query::Request::Boosting::LnFunctionBoost do
  describe '.to_solr_s' do
    subject { described_class.new(field: :machine_type, min: 0.5, boost_magnitude: 16) }

    it { expect(subject.to_solr_s).to eq('mul(if(gt(machine_type,1),ln(machine_type),0.5),16)') }
  end
end
