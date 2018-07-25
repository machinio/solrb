module Solr
  class Response
    class RSolrAdapter
      SOLR_INFINITY = '*'.freeze # for cases like [100000 TO *]

      include Solr::SchemaHelper

      attr_reader :request, :rsolr_response

      def initialize(request:, rsolr_response:)
        @request = request
        @rsolr_response = rsolr_response.with_indifferent_access
      end

      def to_response
        documents = parse_documents
        total_count = parse_total_count
        if request.grouping.present?
          group_counts = parse_group_counts
          document_collection = Solr::GroupedDocumentCollection.new(documents: documents,
                                                                    total_count: total_count,
                                                                    group_counts: group_counts)
        else
          document_collection = Solr::DocumentCollection.new(documents: documents, total_count: total_count)
        end
        Solr::Response.new(
          documents: document_collection,
          available_facets: field_facet_collection,
          spellcheck: spellcheck
        )
      end

      private

      def parse_total_count
        if request.grouping.present?
          parse_grouped_total_count(solr_grouping_field)
        else
          parse_regular_total_count
        end
      end

      def parse_grouped_total_count(solr_grouping_field)
        rsolr_response['grouped'][solr_grouping_field]['groups'].reduce(0) do |acc, group|
          acc + group['doclist']['numFound'].to_i
        end
      end

      def parse_regular_total_count
        rsolr_response.dig('response', 'numFound').to_i
      end

      def parse_group_counts
        group_counts = {}
        if request.grouping.present?
          Array(rsolr_response.dig('grouped', solr_grouping_field, 'groups')).each do |group|
            group_counts[group['groupValue']] = group['doclist']['numFound']
          end
        end
        group_counts
      end

      def parse_documents
        if request.grouping.present?
          parse_grouped_documents(solr_grouping_field)
        else
          parse_regular_documents
        end
      end

      def parse_regular_documents
        rsolr_response['response']['docs'].map do |d|
          debug_info = rsolr_response.dig('debug', 'explain', d['id'])
          model_name, id = d['id'].split
          Document.new(id: id.to_i, model_name: model_name, score: d['score'], debug_info: debug_info)
        end
      end

      def parse_grouped_documents(solr_grouping_field)
        Array(rsolr_response.dig('grouped', solr_grouping_field, 'groups')).map do |group|
          Array(group.dig('doclist', 'docs')).map do |doc|
            next unless doc
            debug_info = rsolr_response.dig('debug', 'explain', doc['id'])
            model_name, id = doc['id'].split
            group_information = Document::GroupInformation.new(key: solr_grouping_field, value: group['groupValue'])
            Document.new(id: id.to_i, model_name: model_name, score: doc['score'],
              debug_info: debug_info, group: group_information)
          end
        end.flatten.compact
      end

      def solr_grouping_field
        grouping_field = request.grouping.field
        solarize_field(grouping_field)
      end

      def field_facet_collection
        return [] unless rsolr_response_has_facet_data?

        raw_facet_data = rsolr_response['facets'].except('count')

        parse_facets(raw_facet_data)
      end

      # Each facet could contain subfacets.
      # We need to parse them recursively and store in subfacets array.
      def parse_facets(raw_facet_data)
        raw_facet_data.map do |field_name, facet_data|
          # We need to handle use case when facet_data is not a hash (e.g. query facet request with aggregate function)
          if facet_data.is_a?(Hash)
            parse_facet_hash(field_name, facet_data)
          else
            parse_facet_count(field_name, facet_data)
          end
        end
      end

      def parse_facet_hash(field_name, facet_data)
        count  = facet_data.delete('count')
        facets = facet_data.delete('buckets')

        facet_values =
          Array(facets).map do |facet|
            text  = facet.delete('val')
            count = facet.delete('count')

            Solr::Response::FacetValue.new(text: text, count: count, subfacets: parse_facets(facet))
          end

        Solr::Response::FieldFacets.new(field: field_name,
                                        facet_values: facet_values,
                                        count: count.to_i,
                                        subfacets: parse_facets(facet_data))
      end

      def parse_facet_count(field_name, count)
        Solr::Response::FieldFacets.new(field: field_name,
                                        facet_values: [],
                                        count: count.to_i,
                                        subfacets: [])
      end

      def rsolr_response_has_facet_data?
        rsolr_response['facets'].present?
      end

      def spellcheck
        return Solr::Response::Spellcheck.empty if rsolr_response['spellcheck'].blank?
        Solr::Response::Spellcheck.new(rsolr_response['spellcheck'])
      end
    end
  end
end
