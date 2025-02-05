RSpec.describe Solr::Admin::CoreService do
  let(:service) { described_class.new }
  let(:core_name) { SecureRandom.uuid }
  let(:config_set) { '_default' }

  describe '#create' do
    after do
      service.unload(name: core_name, delete_index: true, delete_data_dir: true)
    end

    it 'creates a new core' do
      response = service.create(name: core_name, config_set: config_set)
      expect(response['responseHeader']['status']).to eq(0)
    end
  end

  describe '#unload' do
    before do
      service.create(name: core_name, config_set: config_set)
    end

    it 'unloads an existing core' do
      response = service.unload(name: core_name)
      expect(response['responseHeader']['status']).to eq(0)
    end
  end

  describe '#reload' do
    before do
      service.create(name: core_name, config_set: config_set)
    end

    after do
      service.unload(name: core_name, delete_index: true, delete_data_dir: true)
    end

    it 'reloads an existing core' do
      response = service.reload(name: core_name)
      expect(response['responseHeader']['status']).to eq(0)
    end
  end

  describe '#rename' do
    let(:new_name) { 'renamed_core' }

    before do
      service.create(name: core_name, config_set: config_set)
    end

    after do
      service.unload(name: new_name, delete_index: true, delete_data_dir: true)
    end

    it 'renames an existing core' do
      response = service.rename(name: core_name, new_name: new_name)
      expect(response['responseHeader']['status']).to eq(0)
    end
  end

  describe '#status' do
    context 'when core exists' do
      before do
        service.create(name: core_name, config_set: config_set)
      end

      after do
        service.unload(name: core_name, delete_index: true, delete_data_dir: true)
      end

      it 'returns core status' do
        response = service.status(name: core_name)
        expect(response['status'][core_name]).to be_a(Hash)
      end
    end

    context 'when core does not exist' do
      it 'returns empty status for the core' do
        response = service.status(name: 'non_existent_core')
        expect(response['status']['non_existent_core']).to eq({})
      end
    end
  end

  describe '#exists?' do
    context 'when core exists' do
      before do
        service.create(name: core_name, config_set: config_set)
      end

      after do
        service.unload(name: core_name, delete_index: true, delete_data_dir: true)
      end

      it 'returns true' do
        expect(service.exists?(name: core_name)).to be true
      end
    end

    context 'when core does not exist' do
      it 'returns false' do
        expect(service.exists?(name: 'non_existent_core')).to be false
      end
    end
  end
end
