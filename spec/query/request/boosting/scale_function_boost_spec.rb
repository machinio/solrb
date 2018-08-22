RSpec.describe Solr::Query::Request::Boosting::ScaleFunctionBoost do
  describe '.to_solr_s' do
    before do
      Solr.configure do |config|
        config.define_core(name: :'test-core') do |f|
          f.field :machine_type
        end
      end
    end

    subject { described_class.new(field: :machine_type, min: 1, max: 5) }

    it { expect(subject.to_solr_s(core_name: :'test-core')).to eq('scale(machine_type,1,5)') }
  end
end
