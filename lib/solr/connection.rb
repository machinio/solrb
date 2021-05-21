module Solr
  # low-level connection that can do network requests to Solr
  class Connection
    INSTRUMENT_KEY = 'request.solrb'.freeze

    def initialize(url, faraday_options: Solr.configuration.faraday_options,
        faraday_configuration: Solr.configuration.faraday_configuration)
      # Allow mock the connection for testing
      @raw_connection = Solr.configuration.test_connection
      @raw_connection ||= build_faraday_connection(url, faraday_options, faraday_configuration)
      freeze
    end

    def self.call(url:, method:, body:)
      raise "HTTP method not supported: #{method}" unless [:get, :post].include?(method.to_sym)
      new(url).public_send(method, body)
    end

    def get(_)
      Solr.instrument(name: INSTRUMENT_KEY) { @raw_connection.get }
    end

    def post(data)
      Solr.instrument(name: INSTRUMENT_KEY, data: data) do
        @raw_connection.post do |req|
          req.headers['Content-Type'] = 'application/json'.freeze
          req.body = JSON.generate(data)
        end
      end
    end

    private

    def build_faraday_connection(url, faraday_options, faraday_configuration)
      connection = Faraday.new(url, faraday_options, &faraday_configuration)
      if Solr.configuration.auth_user && Solr.configuration.auth_password
        connection.basic_auth(Solr.configuration.auth_user, Solr.configuration.auth_password)
      end
      connection
    end
  end
end
