RSpec.describe Solr::SchemaHelper do
  include Solr::SchemaHelper

  after(:each) do
    # Reset configuration
    Solr.configuration = Solr::Configuration.new
  end

  context 'solarize_field' do
    before do
      Solr.configure do |config|
        config.define_fields do |f|
          f.field :description
          f.field :title, dynamic_field: :text
          f.field :tags, solr_name: :tags_array
          f.dynamic_field :text, solr_name: '*_text'
        end
      end
    end

    context 'regular field' do
      it { expect(solarize_field(:description)).to eq('description') }
    end

    context 'dynamic field' do
      it { expect(solarize_field(:title)).to eq('title_text') }
    end

    context 'solr_name field' do
      it { expect(solarize_field(:tags)).to eq('tags_array') }
    end

    context 'undefined field' do
      it { expect(solarize_field(:undefined_field)).to eq('undefined_field') }
    end
  end
end
