module Solr
  module Query
    class Request
      class Runner
        PATH = '/select'.freeze

        include Solr::Support::ConnectionHelper

        attr_reader :page, :page_size, :offset, :rows, :solr_params

        class << self
          def run(opts)
            new(opts).run
          end
        end

        def initialize(page: nil, page_size: nil, rows: nil, offset: nil, solr_params: {})
          @page = page
          @page_size = page_size
          @offset = offset
          @rows = rows
          @solr_params = solr_params

          if !((page && page_size) || (rows && offset))
            raise ArgumentError.new("Expected one of the following argument pairs: (page, page_size) or (rows, offset)")
          end
        end

        def run
          raw_response = connection(PATH).post_as_json(request_params)
          response = Solr::Response.from_raw_response(raw_response)
          response
        end

        private

        def start
          return offset.to_i if offset

          start_page = @page.to_i - 1
          start_page = start_page < 1 ? 0 : start_page
          start_page * page_size
        end

        def request_params
          # https://lucene.apache.org/solr/guide/7_1/json-request-api.html#passing-parameters-via-json
          @request_params ||= { params: solr_params.merge(wt: :json, rows: row_count, start: start) }
        end

        def row_count
          return rows.to_i if rows
          page_size.to_i
        end
      end
    end
  end
end
