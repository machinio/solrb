module Solr
  module Schema
    BOOST_FIELDS = %i().freeze

    FILTER_FIELD_MAP = {}.with_indifferent_access.freeze

    INVERSE_FILTER_FIELD_MAP = FILTER_FIELD_MAP.invert.with_indifferent_access.freeze
  end
end
