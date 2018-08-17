module Solr
  module Query
    class Request
      class Runner
        SOLR_SELECT_PATH = 'select'.freeze

        include Solr::Support::ConnectionHelper

        attr_reader :core_name, :page, :page_size, :solr_params

        class << self
          def run(opts)
            new(opts).run
          end
        end

        def initialize(core_name:, page:, page_size:, solr_params: {})
          @core_name = core_name
          @page = page
          @page_size = page_size
          @solr_params = solr_params
        end

        def run
          raw_response = connection(path).post_as_json(request_params)
          response = Solr::Response.from_raw_response(raw_response)
          Solr.instrument(name: 'solrb.request_response_cycle',
                          data: { request: request_params, response: raw_response })
          response
        end

        private

        def path
          File.join('/', core_name.to_s, SOLR_SELECT_PATH)
        end

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
