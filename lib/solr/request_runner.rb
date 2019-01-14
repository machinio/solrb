class RequestRunner
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def run(page: 1, page_size: 10)
    solr_response = Solr::Query::Request::Runner.run(page: page, page_size: page_size, solr_params: solr_params)
    raise Solr::Errors::SolrQueryError, solr_response.error_message unless solr_response.ok?
    Solr::Query::Response::Parser.new(request: self, solr_response: solr_response.body).to_response
  end
end
