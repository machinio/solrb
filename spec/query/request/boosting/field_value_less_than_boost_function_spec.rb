RSpec.describe Solr::Query::Request::Boosting::FieldValueLessThanBoostFunction do
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

    subject { described_class.new(field: :machine_type, max: 10, boost_magnitude: 16) }

    it { expect(subject.to_solr_s(core_name: :'test-core')).to eq('if(sub(10,max(machine_type,10)),1,16)') }
  end
end
