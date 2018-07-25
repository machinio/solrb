module Solr
  class Request
    class EdismaxAdapter
      SOLR_INFINITY = '*'.freeze # for cases like [100000 TO *]
      include Solr::SchemaHelper

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
        rsolr_params = { q: request.search_term, defType: :edismax }
        rsolr_params = add_query_fields(rsolr_params)
        rsolr_params = add_response_fields(rsolr_params)
        rsolr_params = add_filters(rsolr_params)
        rsolr_params = add_facets(rsolr_params)
        rsolr_params = add_boosting(rsolr_params)
        rsolr_params = add_grouping(rsolr_params)
        rsolr_params = add_sorting(rsolr_params)
        rsolr_params = add_debug(rsolr_params)
        rsolr_params = add_spellcheck(rsolr_params)
        rsolr_params = add_rerank_query(rsolr_params)
        rsolr_params = add_phrase_slop(rsolr_params)
        PrettyPrintHelper.pp(rsolr_params)
        rsolr_params
      end

      private

      def add_query_fields(rsolr_params)
        fields = request.fields.map(&:to_solr_s)
        rsolr_params.merge(EDISMAX_QUERY_FIELDS => fields)
      end

      def add_filters(rsolr_params)
        filters = []
        filters << "type:#{request.document_type}"
        filters += request.filters.map(&:to_solr_s)
        rsolr_params.merge(EDISMAX_FILTER_QUERY => filters)
      end

      def add_facets(rsolr_params)
        return rsolr_params if Array(request.facets).empty?

        rsolr_params['json.facet'] = request.facets.map(&:to_solr_h).reduce(&:merge).to_json

        rsolr_params
      end

      def add_boosting(rsolr_params)
        rsolr_params = add_additive_boost_functions(rsolr_params)
        rsolr_params = add_multiplicative_boost_functions(rsolr_params)
        add_phrase_boosts(rsolr_params)
      end

      def add_additive_boost_functions(rsolr_params)
        additive_boosts = request.boosting.additive_boost_functions.map(&:to_solr_s)
        if additive_boosts.any?
          rsolr_params.merge(EDISMAX_ADDITIVE_BOOST_FUNCTION => additive_boosts)
        else
          rsolr_params
        end
      end

      def add_multiplicative_boost_functions(rsolr_params)
        multiplicative_boosts = request.boosting.multiplicative_boost_functions.map(&:to_solr_s)
        if multiplicative_boosts.any?
          rsolr_params = rsolr_params.merge(EDISMAX_MULTIPLICATIVE_BOOST_FUNCTION => multiplicative_boosts)
          # https://stackoverflow.com/questions/47025453/
          maybe_add_spatial_fields(rsolr_params, request.boosting.spatial_boost)
        else
          rsolr_params
        end
      end

      def add_phrase_boosts(rsolr_params)
        solr_phrase_boosts = request.boosting.phrase_boosts.map(&:to_solr_s)
        if solr_phrase_boosts.any?
          rsolr_params.merge(EDISMAX_PHRASE_BOOST => solr_phrase_boosts)
        else
          rsolr_params
        end
      end

      def maybe_add_spatial_fields(rsolr_params, geodist_function)
        if geodist_function
          rsolr_params.merge(pt: geodist_function.latlng, sfield: geodist_function.sfield)
        else
          rsolr_params
        end
      end

      def add_grouping(rsolr_params)
        return rsolr_params if request.grouping.empty?
        group_info = {
          'group' => true,
          'group.format' => 'grouped',
          'group.limit' => request.grouping.limit,
          'group.field' => solarize_field(request.grouping.field)
        }
        rsolr_params.merge(group_info)
      end

      def add_sorting(rsolr_params)
        return rsolr_params if request.sorting.empty?
        # sorting nulls last, not-nulls first
        solr_sorting = request.sorting.fields.map do |sort_field|
          solr_field = solarize_field(sort_field.name)
          "exists(#{solr_field}) desc, #{solr_field} #{sort_field.direction}"
        end
        rsolr_params.merge(sort: solr_sorting)
      end

      def add_response_fields(rsolr_params)
        response_fields = 'id'
        response_fields += ',score' if debug_mode?
        rsolr_params.merge(RESPONSE_FIELDS => response_fields)
      end

      def add_debug(rsolr_params)
        rsolr_params.merge(debug: debug_mode?)
      end

      def debug_mode?
        request.debug_mode
      end

      def add_spellcheck(rsolr_params)
        rsolr_params.merge(request.spellcheck.to_h)
      end

      def add_rerank_query(rsolr_params)
        return rsolr_params unless request.limit_docs_by_field
        rerank_query = request.limit_docs_by_field.to_solr_s
        rsolr_params.merge(RERANK_QUERY => rerank_query)
      end

      def add_phrase_slop(rsolr_params)
        return rsolr_params unless request.phrase_slop
        rsolr_params.merge(EDISMAX_PHRASE_SLOP => request.phrase_slop)
      end
    end
  end
end
