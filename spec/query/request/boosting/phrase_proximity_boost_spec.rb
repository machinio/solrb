RSpec.describe Solr::Query::Request::Boosting::PhraseProximityBoost do
  describe '.to_solr_s' do
    before do
      Solr.configure do |config|
        config.define_core(name: :'test-core') do |f|
          f.field :machine_type
        end
      end
    end

    subject { described_class.new(field: :machine_type, boost_magnitude: 16) }

    it { expect(subject.to_solr_s).to eq('machine_type^16') }
  end
end
