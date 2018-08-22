RSpec.describe Solr::Query::Request::Boosting::RecentFieldValueBoostFunction do
  describe '.to_solr_s' do
    before do
      Solr.configure do |config|
        config.define_core(name: :'test-core') do |f|
          f.field :machine_type
        end
      end
    end

    subject { described_class.new(field: :machine_type, boost_magnitude: 16, max_age_days: 14) }

    it { expect(subject.to_solr_s(core_name: :'test-core')).to eq('mul(16,recip(ms(NOW,machine_type),8.267195767195767e-10,0.5,0.1))') }
  end
end
