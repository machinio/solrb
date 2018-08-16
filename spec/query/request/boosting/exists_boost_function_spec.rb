RSpec.describe Solr::Query::Request::Boosting::ExistsBoostFunction do
  describe '.to_solr_s' do
    before do
      Solr.configure do |config|
        config.define_core(name: :default) do |f|
          f.field :machine_type
        end
      end
    end

    subject { described_class.new(core_name: :default, field: :machine_type, boost_magnitude: 16) }

    it { expect(subject.to_solr_s).to eq('if(exists(machine_type),16,1)') }
  end
end
