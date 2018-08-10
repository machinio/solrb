module Solr
  module Testing
    class << self
      attr_reader :last_solr_request_params, :last_solr_response

      def subscribe_to_events
        if defined? ActiveSupport::Notifications
          ActiveSupport::Notifications.subscribe('solrb.request_response_cycle') do |*args|
            event = ActiveSupport::Notifications::Event.new(*args)
            @last_solr_request_params = event.payload[:request][:params]
            @last_solr_response = event.payload[:response]
          end
        end
      end
    end
  end
end

Solr::Testing.subscribe_to_events
