RSpec.describe Solr::Query::Request::Boosting::LnFunctionBoost do
  describe '.to_solr_s' do
    before do
      Solr.configure do |config|
        config.define_core(name: :'test-core') do |f|
          f.field :machine_type
        end
      end
    end

    after do
      # Reset configuration
      Solr.configuration = Solr::Configuration.new
    end

    subject { described_class.new(field: :machine_type, min: 0.5, boost_magnitude: 16) }

    it { expect(subject.to_solr_s(core_name: :'test-core')).to eq('mul(if(gt(machine_type,1),ln(machine_type),0.5),16)') }
  end
end
