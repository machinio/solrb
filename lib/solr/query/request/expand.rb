module Solr
  module Query
    class Request
      class Expand
        attr_reader :sort, :rows, :q, :fq

        def initialize(sort: nil, rows: nil, q: nil, fq: nil)
          @sort = sort
          @rows = rows
          @q = q
          @fq = fq

          freeze
        end

        def to_h
          solr_params = { expand: true }
          solr_params[:'expand.sort'] = sort if sort
          solr_params[:'expand.rows'] = rows if rows
          solr_params[:'expand.q'] = q if q
          solr_params[:'expand.fq'] = fq if fq
          solr_params
        end
      end
    end
  end
end
