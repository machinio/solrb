module Solr
  module Testing
    class << self
      attr_reader :last_solr_request_params, :last_solr_response

      def set_last_solr_request_response(request_params, response)
        @last_solr_request_params = request_params[:params]
        @last_solr_response = response
      end
    end
  end
end
