module Solr
  module Query
    class Request
      class EdismaxAdapter
        SOLR_INFINITY = '*'.freeze # for cases like [100000 TO *]
        include Solr::Support::SchemaHelper

        EDISMAX_QUERY_FIELDS = :qf
        EDISMAX_FILTER_QUERY = :fq
        EDISMAX_ADDITIVE_BOOST_FUNCTION = :bf
        EDISMAX_MULTIPLICATIVE_BOOST_FUNCTION = :boost
        EDISMAX_PHRASE_BOOST = :pf
        EDISMAX_PHRASE_SLOP = :ps
        RESPONSE_FIELDS = :fl
        RERANK_QUERY = :rq

        attr_reader :request

        def initialize(request)
          @request = request
        end

        def to_h
          solr_params = { q: request.search_term, defType: :edismax }
          solr_params = add_query_fields(solr_params)
          solr_params = add_response_fields(solr_params)
          solr_params = add_filters(solr_params)
          solr_params = add_facets(solr_params)
          solr_params = add_boosting(solr_params)
          solr_params = add_grouping(solr_params)
          solr_params = add_sorting(solr_params)
          solr_params = add_debug(solr_params)
          solr_params = add_spellcheck(solr_params)
          solr_params = add_rerank_query(solr_params)
          solr_params = add_phrase_slop(solr_params)
          solr_params
        end

        private

        def add_query_fields(solr_params)
          fields = request.fields.map { |f| f.to_solr_s(core_name: request.core_name) }
          solr_params.merge(EDISMAX_QUERY_FIELDS => fields)
        end

        def add_filters(solr_params)
          filters = request.filters.map { |f| f.to_solr_s(core_name: request.core_name) }
          solr_params.merge(EDISMAX_FILTER_QUERY => filters)
        end

        def add_facets(solr_params)
          return solr_params if Array(request.facets).empty?

          solr_params['json.facet'] = request.facets.map { |f| f.to_solr_h(core_name: request.core_name) }.reduce(&:merge).to_json

          solr_params
        end

        def add_boosting(solr_params)
          return solr_params unless request.boosting
          solr_params = add_additive_boost_functions(solr_params)
          solr_params = add_multiplicative_boost_functions(solr_params)
          add_phrase_boosts(solr_params)
        end

        def add_additive_boost_functions(solr_params)
          additive_boosts = request.boosting.additive_boost_functions.map { |f| f.to_solr_s(core_name: request.core_name) }
          if additive_boosts.any?
            solr_params.merge(EDISMAX_ADDITIVE_BOOST_FUNCTION => additive_boosts)
          else
            solr_params
          end
        end

        def add_multiplicative_boost_functions(solr_params)
          multiplicative_boosts = request.boosting.multiplicative_boost_functions.map { |f| f.to_solr_s(core_name: request.core_name) }
          if multiplicative_boosts.any?
            solr_params = solr_params.merge(EDISMAX_MULTIPLICATIVE_BOOST_FUNCTION => multiplicative_boosts)
            # https://stackoverflow.com/questions/47025453/
            maybe_add_spatial_fields(solr_params, request.boosting.spatial_boost)
          else
            solr_params
          end
        end

        def add_phrase_boosts(solr_params)
          solr_phrase_boosts = request.boosting.phrase_boosts.map { |f| f.to_solr_s(core_name: request.core_name) }
          if solr_phrase_boosts.any?
            solr_params.merge(EDISMAX_PHRASE_BOOST => solr_phrase_boosts)
          else
            solr_params
          end
        end

        def maybe_add_spatial_fields(solr_params, geodist_function)
          if geodist_function
            solr_params.merge(pt: geodist_function.latlng, sfield: geodist_function.sfield(core_name: request.core_name))
          else
            solr_params
          end
        end

        def add_grouping(solr_params)
          return solr_params if request.grouping.empty?
          group_info = {
            'group' => true,
            'group.format' => 'grouped',
            'group.limit' => request.grouping.limit,
            'group.field' => solarize_field(core_name: request.core_name, field: request.grouping.field)
          }
          solr_params.merge(group_info)
        end

        def add_sorting(solr_params)
          return solr_params if request.sorting.empty?
          # sorting nulls last, not-nulls first
          solr_sorting = request.sorting.fields.map do |sort_field|
            solr_field = solarize_field(core_name: request.core_name, field: sort_field.name)
            "exists(#{solr_field}) desc, #{solr_field} #{sort_field.direction}"
          end
          solr_params.merge(sort: solr_sorting)
        end

        def add_response_fields(solr_params)
          response_fields = 'id'
          response_fields += ',score' if debug_mode?
          response_fields += request.response_fields if request.response_fields
          solr_params.merge(RESPONSE_FIELDS => response_fields)
        end

        def add_debug(solr_params)
          solr_params.merge(debug: debug_mode?)
        end

        def debug_mode?
          request.debug_mode
        end

        def add_spellcheck(solr_params)
          solr_params.merge(request.spellcheck.to_h)
        end

        def add_rerank_query(solr_params)
          return solr_params unless request.limit_docs_by_field
          rerank_query = request.limit_docs_by_field.to_solr_s(core_name: core_name)
          solr_params.merge(RERANK_QUERY => rerank_query)
        end

        def add_phrase_slop(solr_params)
          return solr_params unless request.phrase_slop
          solr_params.merge(EDISMAX_PHRASE_SLOP => request.phrase_slop)
        end
      end
    end
  end
end
