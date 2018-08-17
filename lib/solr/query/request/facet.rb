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
                    :upper_bound

        def initialize(field:, type:, name: nil, value: nil, filters: [], subfacets: [], options: {})
          if options[:limit].nil? && type == TERMS_TYPE
            raise ArgumentError, "Need to specify :limit option value for 'terms' facet type"
          end

          if options.values_at(:gap, :lower_bound, :upper_bound).any?(&:nil?) && type == RANGE_TYPE
            raise ArgumentError, "Need to specify :lower_bound, :upper_bound, :gap option values for 'range' facet type"
          end

          @field       = field
          @name        = name || field
          @type        = type
          @value       = value
          @filters     = filters
          @subfacets   = subfacets
          @limit       = options[:limit].to_i
          @gap         = options[:gap]
          @lower_bound = options[:lower_bound]
          @upper_bound = options[:upper_bound]
        end

        def to_solr_h(core_name:)
          return { name.to_s => value } if type == QUERY_TYPE && value

          default_solr_h(core_name: core_name)
        end

        protected

        def default_solr_h(core_name:)
          {
            "#{name}": {
              type: type,
              field: solarize_field(core_name: core_name, field: field),
              limit: limit,
              q: filters.any? ? filters.map { |f| f.to_solr_s(core_name: core_name) }.join(' AND ') : nil,
              facet: subfacets.map { |f| f.to_solr_h(core_name: core_name) }.reduce(&:merge),
              gap: gap,
              start: lower_bound,
              end: upper_bound
            }.compact
          }
        end
      end
    end
  end
end
