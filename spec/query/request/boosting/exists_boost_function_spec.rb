RSpec.describe Solr::Query::Request::Boosting::ExistsBoostFunction do
  describe '.to_solr_s' do
    subject { described_class.new(field: :machine_type, boost_magnitude: 16) }

    it { expect(subject.to_solr_s).to eq('if(exists(machine_type),16,1)') }
  end
end
