RSpec.describe Solr::Query::Request::Boosting::NumericFieldValueMatchBoostFunction do
  describe '.to_solr_s' do
    before do
      Solr.configure do |config|
        config.define_core(name: :'test-core') do |f|
          f.field :machine_type
        end
      end
    end

    subject { described_class.new(field: :machine_type, value: 5, boost_magnitude: 16) }

    it { expect(subject.to_solr_s).to eq('if(sub(def(machine_type,-1),5),1,16)') }
  end
end
