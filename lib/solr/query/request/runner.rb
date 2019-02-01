module Solr
  module Query
    class Request
      class Runner
        PATH = '/select'.freeze

        include Solr::Support::ConnectionHelper

        attr_reader :start, :rows, :solr_params

        class << self
          def run(opts)
            new(opts).run
          end

          def run_paged(page: 1, page_size: 10, solr_params: {})
            start_page = page.to_i - 1
            start_page = start_page < 1 ? 0 : start_page
            start = start_page * page_size

            new(start: start, rows: page_size, solr_params: solr_params).run
          end
        end

        def initialize(rows: nil, start: nil, solr_params: {})
          @start = start
          @rows = rows
          @solr_params = solr_params
        end

        def run
          raw_response = connection(PATH).post_as_json(request_params)
          response = Solr::Response.from_raw_response(raw_response)
          response
        end

        private

        def request_params
          # https://lucene.apache.org/solr/guide/7_1/json-request-api.html#passing-parameters-via-json
          @request_params ||= { params: solr_params.merge(wt: :json, rows: rows, start: start) }
        end
      end
    end
  end
end
