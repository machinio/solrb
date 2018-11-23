module Solr
  # low-level connection that can do network requests to Solr
  class Connection
    INSTRUMENT_KEY = 'request.solrb'.freeze

    def initialize(url, faraday_options: Solr.configuration.faraday_options)
      # Allow mock the connection for testing
      @raw_connection = Solr.configuration.test_connection || build_faraday_connection(url, faraday_options)
      freeze
    end

    def get
      Solr.instrument(name: INSTRUMENT_KEY) { @raw_connection.get }
    end

    def post(data = {})
      Solr.instrument(name: INSTRUMENT_KEY) do
        @raw_connection.post do |req|
          req.body = data
        end
      end
    end

    def post_as_json(data)
      Solr.instrument(name: INSTRUMENT_KEY, data: data) do
        @raw_connection.post do |req|
          req.headers['Content-Type'] = 'application/json'.freeze
          req.body = JSON.generate(data)
        end
      end
    end

    private

    def build_faraday_connection(url, faraday_options)
      connection = Faraday.new(url, faraday_options)
      if Solr.configuration.auth_user && Solr.configuration.auth_password
        connection.basic_auth(Solr.configuration.auth_user, Solr.configuration.auth_password)
      end
      connection
    end
  end
end
