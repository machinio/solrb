RSpec.describe Solr::Query::Request::Boosting::GeodistFunction do
  describe '.to_solr_s' do
    before do
      Solr.configure do |config|
        config.define_core(name: :'test-core') do |f|
          f.field :machine_type
        end
      end
    end

    subject { described_class.new(field: :machine_type, latitude: -25.429692, longitude: -49.271265) }

    it { expect(subject.to_solr_s(core: :'test-core')).to eq('recip(geodist(),3,17000,3000)') }
  end
end
