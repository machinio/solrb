require 'date'

module Solr
  module Query
    class Request
      class Filter
        include Solr::Support::SchemaHelper
        using Solr::Support::StringExtensions

        EQUAL_TYPE = :equal
        NOT_EQUAL_TYPE = :not_equal
        attr_reader :type, :field, :value

        def initialize(type:, field:, value:)
          @type = type
          @field = field
          @value = value
        end

        def to_solr_s
          "#{solr_prefix}#{solr_field}:(#{solr_value})"
        end

        def solr_field
          solarize_field(@field)
        end

        def solr_value
          if value.is_a?(::Array)
            value.map { |v| to_primitive_solr_value(v) }.join(' OR ')
          elsif value.is_a?(::Range)
            to_interval_solr_value(value)
          elsif value.is_a?(Solr::SpatialRectangle)
            value.to_solr_s
          else
            to_primitive_solr_value(value)
          end
        end

        private

        def solr_prefix
          '-' if NOT_EQUAL_TYPE == type
        end

        def to_interval_solr_value(range)
          solr_min = to_primitive_solr_value(range.first)
          solr_max = to_primitive_solr_value(range.last)
          "[#{solr_min} TO #{solr_max}}"
        end

        def to_primitive_solr_value(value)
          if date_infinity?(value) || numeric_infinity?(value)
            '*'
          elsif date_or_time?(value)
            value.strftime('%Y-%m-%dT%H:%M:%SZ')
          else
            %("#{value.to_s.solr_escape}")
          end
        end

        def date_infinity?(value)
          value.is_a?(DateTime::Infinity)
        end

        def numeric_infinity?(value)
          value.is_a?(Numeric) && value.infinite?
        end

        def date_or_time?(value)
          return false unless value
          value.is_a?(::Date) || value.is_a?(::Time)
        end
      end
    end
  end
end
