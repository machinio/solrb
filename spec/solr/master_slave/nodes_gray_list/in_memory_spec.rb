RSpec.describe Solr::MasterSlave::NodesGrayList::InMemory do
  let(:url) { 'http://localhost:8983/solr/' }
  let(:instance) { described_class.new }
  
  describe "#add" do
    context 'added previously' do
      before { instance.gray_list[url] = Time.now.utc }

      subject { instance.add(url) }
      
      specify do
        expect { subject }.not_to change { instance.gray_list[url] }
      end
    end

    context 'not added previously' do
      subject { instance.add(url) }
      
      specify do
        expect { subject }.to change { instance.gray_list.has_key?(url) }.from(false).to(true)
      end
    end
  end

  describe "#remove" do
    before { instance.gray_list[url] = Time.now.utc }

    subject { instance.remove(url) }
    
    specify do
      expect { subject }.to change { instance.gray_list.has_key?(url) }.from(true).to(false)
    end
  end

  describe "#added?" do
    context 'added previously' do
      context 'less than DEFAULT_REMOVAL_PERIOD' do
        before { instance.gray_list[url] = Time.now.utc - (instance.removal_period - 2 * 60) }

        subject { instance.added?(url) }
        
        it { is_expected.to be_truthy }
        specify do
          expect { subject }.not_to change { instance.gray_list.has_key?(url) }
        end
      end

      context 'more than DEFAULT_REMOVAL_PERIOD' do
        before { instance.gray_list[url] = Time.now.utc - (instance.removal_period + 2 * 60) }

        subject { instance.added?(url) }
        
        it { is_expected.to be_falsey }
        specify do
          expect { subject }.to change { instance.gray_list.has_key?(url) }.from(true).to(false)
        end
      end
    end

    context 'not added previously' do
      subject { instance.added?(url) }
      
      it { is_expected.to be_falsey }
    end
  end

  describe "#select_active" do
    let(:first_url) { 'http://localhost:8983/solr/' }
    let(:second_url) { 'http://localhost:8984/solr/' }

    subject { instance.select_active(urls, collection_name: 'test-core') }

    context 'contains only added url' do
      let(:urls) { [first_url] }
      before { instance.gray_list["#{first_url}test-core"] = Time.now.utc }

      it { is_expected.to eq([first_url]) }
    end

    context 'contains not only added url' do
      let(:urls) { [first_url, second_url] }
      before { instance.gray_list["#{first_url}test-core"] = Time.now.utc }

      it { is_expected.to eq([second_url]) }
    end
  end
end
