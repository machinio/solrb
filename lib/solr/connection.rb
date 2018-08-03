module Solr
  # low-level connection that can do network requests to Solr
  class Connection
    def initialize(url, faraday_options: Solr.configuration.faraday_options)
      # Allow mock the connection for testing
      @raw_connection = Solr.test_connection || Faraday.new(url, faraday_options)
      freeze
    end

    def get
    end

    def post
    end

    def post_as_json(data)
      with_instrumentation do
        @raw_connection.post do |req|
          req.headers['Content-Type'] = 'application/json'.freeze
          req.body = JSON.generate(data)
        end
      end
    end

    private

    def with_instrumentation(data: {})
      if defined? ActiveSupport::Notifications
        ActiveSupport::Notifications.instrument('solrb.request', data) do
          yield
        end
      else
        yield
      end
    end
  end
end
