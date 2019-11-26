module Solr
  module Query
    class Request
      class CollapseFilter
        include Solr::Support::SchemaHelper

        attr_reader :field, :min, :max, :sort, :null_policy, :hint, :size

        def initialize(field:, min: nil, max: nil, sort: nil, null_policy: nil, hint: nil, size: nil)
          if [min, max, sort].compact.size > 1
            raise ArgumentError, "At most only one of the min, max, or sort parameters may be specified."
          end

          @field = field
          @min = min
          @max = max
          @sort = sort
          @null_policy = null_policy
          @hint = hint
          @size = size
          freeze
        end

        def to_solr_s
          solr_field = solarize_field(@field)

          parameters = []
          parameters << "field=#{solr_field}"
          parameters << "min=#{min}" if min
          parameters << "max=#{max}" if max
          parameters << "sort=#{sort}" if sort
          parameters << "nullPolicy=#{null_policy}" if null_policy
          parameters << "hint=#{hint}" if hint

          "{!collapse #{parameters.join(' ')}}"
        end
      end
    end
  end
end
