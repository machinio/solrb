RSpec.describe Solr::Query::Request do
  context 'simple request' do
    before do
      Solr.delete_by_query('*:*', commit: true)
      doc = Solr::Indexing::Document.new(id: 42, name_txt_en: 'Solrb')
      Solr::Indexing::Request.new([doc]).run(commit: true)
    end

    after do
      Solr.delete_by_query('*:*', commit: true)
    end

    let(:search_term) { 'solrb' }
    let(:query_fields) do
      [Solr::Query::Request::FieldWithBoost.new(field: :name_txt_en)]
    end

    subject do
      Solr::Query::Request.new(search_term: search_term, query_fields: query_fields)
    end

    it 'searches' do
      response = subject.run(page: 1, page_size: 10)
      expect(response.total_count).to eq(1)
      expect(response.documents.map(&:id)).to eq(['42'])
    end
  end

  context 'collapse & expand request' do
    before do
      Solr.delete_by_query('*:*', commit: true)
      docs = []
      docs << Solr::Indexing::Document.new(id: 42, seller_id_i: 2)
      docs << Solr::Indexing::Document.new(id: 43, seller_id_i: 2)
      docs << Solr::Indexing::Document.new(id: 44, seller_id_i: 3)
      docs << Solr::Indexing::Document.new(id: 45, seller_id_i: 3)
      docs << Solr::Indexing::Document.new(id: 46, seller_id_i: 2)
      docs << Solr::Indexing::Document.new(id: 47, seller_id_i: 2)
      docs << Solr::Indexing::Document.new(id: 48, seller_id_i: 2)
      docs << Solr::Indexing::Document.new(id: 49, seller_id_i: 2)
      docs << Solr::Indexing::Document.new(id: 50, seller_id_i: 2)
      docs << Solr::Indexing::Document.new(id: 51, seller_id_i: 2)
      Solr::Indexing::Request.new(docs).run(commit: true)
    end

    after do
      Solr.delete_by_query('*:*', commit: true)
    end

    let(:search_term) { '*:*' }
    let(:filters) do
      [Solr::Query::Request::CollapseFilter.new(field: :seller_id_i)]
    end
    let(:field_list) do
      Solr::Query::Request::FieldList.new(fields: [:seller_id_i])
    end

    subject do
      request = Solr::Query::Request.new(search_term: search_term, filters: filters, field_list: field_list)
      request.expand = Solr::Query::Request::Expand.new(rows: 3)
      request
    end

    it 'collapses results and adds the expanded section' do
      response = subject.run(page: 1, page_size: 10)
      expect(response.total_count).to eq(2)
      expect(response.documents.map(&:id)).to contain_exactly('42', '44')

      expanded_results = response.expanded_results
      expect(expanded_results.count).to eq(2)

      result_set = expanded_results.find { |r| r.field_value == '2' }
      expect(result_set.count).to eq(3)
      expect(result_set.documents.count).to eq(3)
      expect(result_set.documents.total_count).to eq(7)
      expect(result_set.documents.map(&:id)).to contain_exactly('43', '46', '47')
    end
  end
end
