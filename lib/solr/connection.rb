module Solr
  # low-level connection that can do network requests to Solr
  class Connection
    def initialize(url, faraday_options: Solr.configuration.faraday_options)
      # Allow mock the connection for testing
      @raw_connection = Solr.configuration.test_connection || Faraday.new(url, faraday_options)
      freeze
    end

    def get; end

    def post; end

    def post_as_json(data)
      Solr.instrument(name: 'solrb.request', data: data) do
        @raw_connection.post do |req|
          req.headers['Content-Type'] = 'application/json'.freeze
          req.body = JSON.generate(data)
        end
      end
    end
  end
end
