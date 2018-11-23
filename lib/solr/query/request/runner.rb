module Solr
  module Query
    class Request
      class Runner
        PATH = '/select'.freeze

        attr_reader :page, :page_size, :solr_params

        class << self
          def run(opts)
            new(opts).run
          end
        end

        def initialize(page:, page_size:, solr_params: {})
          @page = page
          @page_size = page_size
          @solr_params = solr_params
        end

        def run
          Solr::Request::Runner.post_as_json(PATH, request_params)
        end

        private

        def start
          start_page = @page.to_i - 1
          start_page = start_page < 1 ? 0 : start_page
          start_page * page_size
        end

        def request_params
          # https://lucene.apache.org/solr/guide/7_1/json-request-api.html#passing-parameters-via-json
          @request_params ||= { params: solr_params.merge(wt: :json, rows: page_size.to_i, start: start) }
        end
      end
    end
  end
end
