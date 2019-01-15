# RSpec.describe Solr::Query::Request::Runner do
#   let(:search_term) { 'solrb' }

#   subject do
#     described_class.new(
#       page: 1,
#       page_size: 10
#     )
#   end

#   context 'without configuration' do
#     it 'runs' do
#       expect { subject.run }.not_to raise_error
#     end
#   end

#   context 'with configuration' do
#     context 'one core' do
#       before do
#         Solr.configure do |config|
#           config.define_core do |f|
#             f.field :machine_type
#           end
#         end
#       end

#       it 'runs' do
#         expect { subject.run }.not_to raise_error
#       end
#     end

#     context 'multiple cores' do
#       context 'without default core' do
#         before do
#           Solr.configure do |config|
#             config.define_core(name: :'test-core') do |f|
#               f.field :machine_type
#             end

#             config.define_core(name: :'test-core-2') do |f|
#               f.field :machine_type
#             end
#           end
#         end

#         context 'request without specified core' do
#           it 'runs' do
#             expect { subject.run }.to raise_error(Solr::Errors::AmbiguousCoreError)
#           end
#         end

#         context 'request with specified core' do
#           it 'runs' do
#             expect {
#               Solr.with_core(:'test-core') { subject.run }
#             }.not_to raise_error
#           end
#         end
#       end

#       context 'with default core' do
#         before do
#           Solr.configure do |config|
#             config.define_core(name: :'test-core', default: true) do |f|
#               f.field :machine_type
#             end

#             config.define_core(name: :'test-core-2') do |f|
#               f.field :machine_type
#             end
#           end
#         end

#         context 'request without specified core' do
#           it 'runs' do
#             expect { subject.run }.not_to raise_error
#           end
#         end

#         context 'request with specified core' do
#           it 'runs' do
#             expect {
#               Solr.with_core(:'test-core') { subject.run }
#             }.not_to raise_error
#           end
#         end
#       end
#     end
#   end
# end
