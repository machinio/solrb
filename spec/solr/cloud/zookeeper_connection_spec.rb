RSpec.describe Solr::Cloud::ZookeeperConnection do
  let(:collection_states) do
    [{'test-collection' =>
      {'pullReplicas' => '0',
       'replicationFactor' => '2',
       'shards' =>
        {'shard1' =>
          {'range' => '80000000-ffffffff',
           'state' => 'active',
           'replicas' =>
            {'core_node3' =>
              {'core' => 'en_shard1_replica_n1',
               'base_url' => 'http://192.168.1.193:8983/solr',
               'node_name' => '192.168.1.193:8983_solr',
               'state' => 'active',
               'type' => 'NRT',
               'force_set_state' => 'false'},
             'core_node5' =>
              {'core' => 'en_shard1_replica_n2',
               'base_url' => 'http://192.168.1.193:7574/solr',
               'node_name' => '192.168.1.193:7574_solr',
               'state' => 'active',
               'type' => 'NRT',
               'force_set_state' => 'false',
               'leader' => 'true'}}},
         'shard2' =>
          {'range' => '0-7fffffff',
           'state' => 'active',
           'replicas' =>
            {'core_node7' =>
              {'core' => 'en_shard2_replica_n4',
               'base_url' => 'http://192.168.1.193:8984/solr',
               'node_name' => '192.168.1.193:8984_solr',
               'state' => 'down',
               'type' => 'NRT',
               'force_set_state' => 'false'},
             'core_node8' =>
              {'core' => 'en_shard2_replica_n6',
               'base_url' => 'http://192.168.1.193:7575/solr',
               'node_name' => '192.168.1.193:7575_solr',
               'state' => 'active',
               'type' => 'NRT',
               'force_set_state' => 'false',
               'leader' => 'true'}}}},
       'router' => {'name' => 'compositeId'},
       'maxShardsPerNode' => '2',
       'autoAddReplicas' => 'false',
       'nrtReplicas' => '2',
       'tlogReplicas' => '0'}}.to_json]
  end
  let(:test_collection_state) { JSON.parse(collection_states.first)['test-collection'] }
  let(:zookeeper) { double(:zookeeper, register: true, get: collection_states) }

  before do
    allow_any_instance_of(described_class).to receive(:zookeeper_connection).and_return(zookeeper)
  end

  subject { described_class.new(zookeeper_url: 'localhost:2181') }

  describe '.watch_collection_state' do
    it 'register a callback on zookeeper' do
      expect(zookeeper).to receive(:register).with('/collections/test-collection/state.json')
      subject.watch_collection_state('test-collection') { |_| }
    end

    it 'yields the collection state' do
      expect { |b| subject.watch_collection_state('test-collection', &b) }.to yield_with_args(test_collection_state)
    end
  end

  describe '.get_collection_state' do
    it 'returns the collection state' do
      expect(subject.get_collection_state('test-collection')).to eq(test_collection_state)
    end
  end

  describe '.collection_state_znode_path' do
    it 'returns collection znode path' do
      expect(subject.collection_state_znode_path(:collection)).to eq('/collections/collection/state.json')
    end
  end
end
