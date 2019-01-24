module Solr
  module Query
    class Response
      class Parser
        SOLR_INFINITY = '*'.freeze # for cases like [100000 TO *]

        include Solr::Support::SchemaHelper

        attr_reader :request, :solr_response

        def initialize(request:, solr_response:)
          @request = request
          @solr_response = solr_response
        end

        def to_response
          documents = parse_documents
          total_count = parse_total_count
          if !request.grouping.empty?
            group_counts = parse_group_counts
            document_collection = Solr::GroupedDocumentCollection.new(documents: documents,
                                                                      total_count: total_count,
                                                                      group_counts: group_counts)
          else
            document_collection = Solr::DocumentCollection.new(documents: documents, total_count: total_count)
          end
          Solr::Query::Response.new(
            documents: document_collection,
            available_facets: field_facet_collection,
            spellcheck: spellcheck
          )
        end

        private

        def parse_total_count
          if !request.grouping.empty?
            parse_grouped_total_count(solr_grouping_field)
          else
            parse_regular_total_count
          end
        end

        def parse_grouped_total_count(solr_grouping_field)
          solr_response['grouped'][solr_grouping_field]['groups'].reduce(0) do |acc, group|
            acc + group['doclist']['numFound'].to_i
          end
        end

        def parse_regular_total_count
          solr_response.dig('response', 'numFound').to_i
        end

        def parse_group_counts
          group_counts = {}
          unless request.grouping.empty?
            Array(solr_response.dig('grouped', solr_grouping_field, 'groups')).each do |group|
              group_counts[group['groupValue']] = group['doclist']['numFound']
            end
          end
          group_counts
        end

        def parse_documents
          if !request.grouping.empty?
            parse_grouped_documents(solr_grouping_field)
          else
            parse_regular_documents
          end
        end

        def parse_regular_documents
          solr_response['response']['docs'].map do |d|
            debug_info = solr_response.dig('debug', 'explain', d['id'])
            fields = d.dup.tap { |hs| hs.delete('id', 'score') }
            Document.new(id: d['id'], score: d['score'], debug_info: debug_info, fields: fields)
          end
        end

        def parse_grouped_documents(solr_grouping_field)
          Array(solr_response.dig('grouped', solr_grouping_field, 'groups')).map do |group|
            Array(group.dig('doclist', 'docs')).map do |doc|
              next unless doc
              debug_info = solr_response.dig('debug', 'explain', doc['id'])
              group_information = Document::GroupInformation.new(key: solr_grouping_field, value: group['groupValue'])
              fields = doc.dup.tap { |hs| hs.delete('id', 'score') }
              Document.new(id: doc['id'], score: doc['score'],
                           debug_info: debug_info, group: group_information, fields: fields)
            end
          end.flatten.compact
        end

        def solr_grouping_field
          grouping_field = request.grouping.field
          solarize_field(grouping_field)
        end

        def field_facet_collection
          return [] unless solr_response_has_facet_data?

          raw_facet_data = solr_response['facets'].except('count')

          parse_facets(raw_facet_data)
        end

        # Each facet could contain subfacets.
        # We need to parse them recursively and store in subfacets array.
        def parse_facets(raw_facet_data)
          raw_facet_data.map do |field_name, facet_data|
            # We need to handle use case when facet_data is not a hash
            # (e.g. query facet request with aggregate function)
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

              Solr::Query::Response::FacetValue.new(text: text, count: count, subfacets: parse_facets(facet))
            end

          Solr::Query::Response::FieldFacets.new(field: field_name,
                                                 facet_values: facet_values,
                                                 count: count.to_i,
                                                 subfacets: parse_facets(facet_data))
        end

        def parse_facet_count(field_name, count)
          Solr::Query::Response::FieldFacets.new(field: field_name,
                                                 facet_values: [],
                                                 count: count.to_i,
                                                 subfacets: [])
        end

        def solr_response_has_facet_data?
          solr_response['facets']
        end

        def spellcheck
          return Solr::Query::Response::Spellcheck.empty unless solr_response['spellcheck']
          Solr::Query::Response::Spellcheck.new(solr_response['spellcheck'])
        end
      end
    end
  end
end
