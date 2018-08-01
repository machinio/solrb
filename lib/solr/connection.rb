module Solr
  # low-level connection that can do network requests to Solr
  class Connection

    def initialize(url, faraday_options: {})
      @raw_connection = Faraday.new(url, faraday_options)
      freeze
    end


    def get()
    end

    def post()
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
        ActiveSupport::Notifications.instrument('solrb.request') do
          yield
        end
      else
        yield
      end
    end
  end
end