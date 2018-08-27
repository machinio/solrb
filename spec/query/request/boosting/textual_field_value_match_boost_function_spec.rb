RSpec.describe Solr::Query::Request::Boosting::TextualFieldValueMatchBoostFunction do
  describe '.to_solr_s' do
    before do
      Solr.configure do |config|
        config.define_core(name: :'test-core') do |f|
          f.field :machine_type
        end
      end
    end

    subject { described_class.new(field: :machine_type, value: 'value', boost_magnitude: 16) }

    it { expect(subject.to_solr_s).to eq('if(termfreq(machine_type,\'value\'),16,1)') }
  end
end
