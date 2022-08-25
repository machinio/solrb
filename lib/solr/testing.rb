module Solr
  module Testing
    class << self
      attr_accessor :last_solr_request
    end
  end
end

module Solr::Request::RunnerExtension
  def call
    response = super
    Solr::Testing.last_solr_request = request
    response
  end
end

class Solr::Request::Runner
  prepend Solr::Request::RunnerExtension
end
