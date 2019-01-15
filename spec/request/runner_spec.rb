# RSpec.describe Solr::Request::Runner do
#   context 'when solr cloud is not enabled' do
#     it 'uses SingleSolrInstanceRouter' do
#       expect(Solr::Request::SingleSolrInstanceRouter).to receive(:run)
#       described_class.post('/select', {})
#     end
#   end

#   context 'when solr cloud is enabled' do
#     before do
#       Solr.configure do |config|
#         config.zookeeper_url = 'localhost:2181'
#       end
#       Solr.enable_solr_cloud
#     end

#     it 'uses SolrCloudRouter' do
#       expect(Solr::Request::SolrCloudRouter).to receive(:run)
#       described_class.post('/select', {})
#     end
#   end
# end