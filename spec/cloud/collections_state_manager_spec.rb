RSpec.describe Solr::Cloud::CollectionsStateManager do
  let(:collection_states) do
    {'en' =>
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
       'tlogReplicas' => '0'}}
  end
  let(:zookeeper) { double(:zookeeper, watch_collection_state: true) }

  describe '.shards_for' do
    subject { described_class.new(zookeeper: zookeeper, collections: [:en]) }

    before do
      allow(subject).to receive(:collections_state).and_return(collection_states)
    end

    it 'return all shards' do
      expect(subject.shards_for(collection: :en)).to eq(['shard1', 'shard2'])
    end
  end

  describe '.active_nodes_for' do
    let(:expected_urls) { ['http://192.168.1.193:8983/solr', 'http://192.168.1.193:7574/solr', 'http://192.168.1.193:7575/solr'] }

    subject { described_class.new(zookeeper: zookeeper, collections: [:en]) }

    before do
      allow(subject).to receive(:collections_state).and_return(collection_states)
    end

    it 'return only active solr nodes' do
      expect(subject.active_nodes_for(collection: :en)).to eq(expected_urls)
    end
  end

  describe '.leader_replica_node_for' do
    let(:expected_urls) { 'http://192.168.1.193:7574/solr' }

    subject { described_class.new(zookeeper: zookeeper, collections: [:en]) }

    before do
      allow(subject).to receive(:collections_state).and_return(collection_states)
    end

    it 'return shard leader node' do
      expect(subject.leader_replica_node_for(collection: :en, shard: 'shard1')).to eq(expected_urls)
    end
  end

  describe '.watch_solr_collections_state' do
    let(:zookeeper) { double(:zookeeper, watch_collection_state: true) }

    it 'watches zookeeper znodes for all defined collections' do
      expect(zookeeper).to receive(:watch_collection_state).with(:en).and_return(['{}'])
      described_class.new(zookeeper: zookeeper, collections: [:en])
    end
  end
end
