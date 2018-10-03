module Solr
  module Testing
    class << self
      attr_accessor :last_solr_request_params
    end
  end
end

module Solr::Query::Request::RunnerExtension
  def run
    response = super
    Solr::Testing.last_solr_request_params = request_params[:params]
    response
  end
end

class Solr::Query::Request::Runner
  prepend Solr::Query::Request::RunnerExtension
end
