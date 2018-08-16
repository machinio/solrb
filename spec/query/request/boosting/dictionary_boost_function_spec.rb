RSpec.describe Solr::Query::Request::Boosting::DictionaryBoostFunction do
  describe '.to_solr_s' do
    before do
      Solr.configure do |config|
        config.define_core(name: :default) do |f|
          f.field :machine_type
        end
      end
    end

    context 'when field value is string or symbol' do
      let(:expected_result) do
        'if(termfreq(machine_type,"tractor"),2.0,if(termfreq(machine_type,"truck"),1.5,1))'
      end

      let(:dictionary) do
        { 'tractor' => 2.0, truck: 1.5 }
      end

      subject { described_class.new(core_name: :default, field: :machine_type, dictionary: dictionary) }

      it { expect(subject.to_solr_s).to eq(expected_result) }
    end

    context 'when field value is not string or symbol' do
      let(:expected_result) do
        'if(eq(machine_type,3025),2.0,if(eq(machine_type,1200),1.5,1))'
      end

      let(:dictionary) do
        { 3025 => 2.0, 1200 => 1.5 }
      end

      subject { described_class.new(core_name: :default, field: :machine_type, dictionary: dictionary) }

      it { expect(subject.to_solr_s).to eq(expected_result) }
    end
  end
end
