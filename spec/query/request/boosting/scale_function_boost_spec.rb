RSpec.describe Solr::Query::Request::Boosting::ScaleFunctionBoost do
  describe '.to_solr_s' do
    before do
      Solr.configure do |config|
        config.define_core(name: :default) do |f|
          f.field :machine_type
        end
      end
    end

    subject { described_class.new(core_name: :default, field: :machine_type, min: 1, max: 5) }

    it { expect(subject.to_solr_s).to eq('scale(machine_type,1,5)') }
  end
end
