module Solr
  class Request
    class Filter
      include Solr::SchemaHelper

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
        else
          to_primitive_solr_value(value)
        end
      end

      private

      def solr_prefix
        '-' if NOT_EQUAL_TYPE == @type
      end

      def to_interval_solr_value(range)
        solr_min = to_primitive_solr_value(range.min)
        solr_max = if date_infinity?(range.max) || range.max.to_f.infinite?
                     '*'
                   else
                     to_primitive_solr_value(range.max)
                   end
        "[#{solr_min} TO #{solr_max}]"
      end

      def to_primitive_solr_value(value)
        if date_or_time?(value)
          value.strftime('%Y-%m-%dT%H:%M:%SZ')
        else
          %("#{Solrb::Utils.solr_escape(value.to_s)}")
        end
      end

      def date_infinity?(value)
        value.is_a?(DateTime::Infinity)
      end

      def date_or_time?(value)
        return false unless value
        value.is_a?(::Date) || value.is_a?(::Time)
      end
    end
  end
end
