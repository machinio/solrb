RSpec.describe Solr::Query::Request::EdismaxAdapter do
  before do
    Solr.configure do |config|
      config.define_core(name: :'test-core') do |f|
        f.field :machine_type
      end
    end
  end

  let(:document_type) { 'document_type' }
  let(:search_term) { 'Search Term' }

  subject { described_class.new(request) }

  context 'simple query' do
    let(:request) { Solr::Query::Request.new(search_term: search_term) }
    let(:solr_params) do
      {
        debug: nil,
        defType: :edismax,
        fl: 'id',
        fq: [],
        q: 'Search Term',
        qf: []
      }
    end

    it { expect(subject.to_h).to eq(solr_params) }
  end

  context 'complex query' do
    let(:query_fields) do
      [
        Solr::Query::Request::FieldWithBoost.new(field: :field_1),
        Solr::Query::Request::FieldWithBoost.new(field: :field_2, boost_magnitude: 16)
      ]
    end

    let(:field_list) do
      Solr::Query::Request::FieldList.new(fields: [:name])
    end

    let(:filters) do
      [Solr::Query::Request::Filter.new(type: :equal, field: :field_1, value: 'value')]
    end

    let(:boosting) do
      Solr::Query::Request::Boosting.new(
        multiplicative_boost_functions: [
          Solr::Query::Request::Boosting::RankingFieldBoostFunction.new(field: :field_1)
        ],
        phrase_boosts: [
          Solr::Query::Request::Boosting::PhraseProximityBoost.new(field: :field_2, boost_magnitude: 4)
        ]
      )
    end

    let(:grouping) do
      Solr::Query::Request::Grouping.new(field: :field_1, limit: 10)
    end

    let(:sorting) do
      sort_fields = [
        Solr::Query::Request::Sorting::Field.new(name: :field_1, direction: :asc),
        Solr::Query::Request::Sorting::Field.new(name: :field_2, direction: :desc),
        Solr::Query::Request::Sorting::Function.new(function: 'score desc')
      ]
      Solr::Query::Request::Sorting.new(fields: sort_fields)
    end

    let(:facets) do
      [Solr::Query::Request::Facet.new(type: :terms, field: :field_1, options: { limit: 10 })]
    end

    let(:shards_preference) do
      Solr::Query::Request::ShardsPreference.new(
        properties: [
          Solr::Query::Request::ShardsPreferences::Property.new(name: 'replica.type', value: 'PULL')
        ]
      end
    end

    let(:request) do
      request = Solr::Query::Request.new(search_term: search_term)
      request.query_fields = query_fields
      request.field_list = field_list
      request.filters = filters
      request.facets = facets
      request.boosting = boosting
      request.grouping = grouping
      request.sorting = sorting
      request.phrase_slop = 5
      request.query_operator = :AND
      request.shards_preference = shards_preference
      request
    end

    let(:solr_params) do
      {
        'group' => true,
        'group.field' => 'field_1',
        'group.format' => 'grouped',
        'group.limit' => 10,
        :'json.facet' => '{"field_1":{"type":"terms","field":"field_1","limit":10}}',
        boost: ['field_1'],
        debug: nil,
        defType: :edismax,
        fl: 'id,name',
        fq: ['field_1:("value")'],
        pf: ['field_2^4'],
        ps: 5,
        q: 'Search Term',
        'q.op': :AND,
        qf: ['field_1^1', 'field_2^16'],
        sort: 'exists(field_1) desc, field_1 asc, exists(field_2) desc, field_2 desc, score desc'
      }
    end

    it { expect(subject.to_h).to eq(solr_params) }
  end

  context 'nested AND and OR filters' do
    let(:filters) do
      [
        Solr::Query::Request::OrFilter.new(
          Solr::Query::Request::AndFilter.new(
            Solr::Query::Request::Filter.new(type: :equal, field: :field_1, value: 'value1'),
            Solr::Query::Request::Filter.new(type: :equal, field: :field_2, value: 'value2')
          ),
          Solr::Query::Request::AndFilter.new(
            Solr::Query::Request::Filter.new(type: :equal, field: :field_3, value: 'value3'),
            Solr::Query::Request::Filter.new(type: :equal, field: :field_4, value: 'value4')
          )
        )
      ]
    end

    let(:request) do
      request = Solr::Query::Request.new(search_term: search_term)
      request.filters = filters
      request
    end

    let(:solr_params) do
      {
        debug: nil,
        defType: :edismax,
        fl: 'id',
        fq: ['((field_1:("value1") AND field_2:("value2")) OR (field_3:("value3") AND field_4:("value4")))'],
        q: 'Search Term',
        qf: []
      }
    end

    it { expect(subject.to_h).to eq(solr_params) }
  end
end
