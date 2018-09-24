module Solr
  module Query
    class Request
      class Facet
        include Solr::Support::SchemaHelper

        TERMS_TYPE = :terms
        QUERY_TYPE = :query
        RANGE_TYPE = :range

        attr_reader :field,
                    :type,
                    :name,
                    :value,
                    :limit,
                    :filters,
                    :subfacets,
                    :gap,
                    :lower_bound,
                    :upper_bound,
                    :facet_filters

        def initialize(field:, type:, name: nil, value: nil, filters: [], subfacets: [], options: {})
          if options[:limit].nil? && type == TERMS_TYPE
            raise ArgumentError, "Need to specify :limit option value for 'terms' facet type"
          end

          if options.values_at(:gap, :lower_bound, :upper_bound).any?(&:nil?) && type == RANGE_TYPE
            raise ArgumentError, "Need to specify :lower_bound, :upper_bound, :gap option values for 'range' facet type"
          end

          @field        = field
          @name         = name || field
          @type         = type
          @value        = value
          @filters      = filters
          @subfacets    = subfacets
          @limit        = options[:limit].to_i
          @gap          = options[:gap]
          @lower_bound  = options[:lower_bound]
          @upper_bound  = options[:upper_bound]
          @facet_filters = options[:facet_filters] || []
        end

        def to_solr_h
          return { name.to_s => value } if type == QUERY_TYPE && value

          default_solr_h
        end

        protected

        def default_solr_h
          {
            "#{name}": {
              type: type,
              field: solarize_field(field),
              limit: limit,
              q: filters.any? ? filters.map(&:to_solr_s).join(' AND ') : nil,
              facet: subfacets.map(&:to_solr_h).reduce(&:merge),
              gap: gap,
              start: lower_bound,
              end: upper_bound,
              domain: build_domain_params
            }.compact
          }
        end

        def build_domain_params
          return unless facet_filters.any?
          { filter: facet_filters.map(&:to_solr_s).join(' AND ') }
        end
      end
    end
  end
end
