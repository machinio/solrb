require 'solr/response/header'
require 'solr/response/http_status'
require 'solr/response/solr_error'
require 'solr/response/parser'

module Solr
  class Response
    def self.from_raw_response(response)
      Solr::Response::Parser.new(response).parse
    end

    attr_reader :header, :http_status, :solr_error

    def initialize(header:, http_status: HttpStatus.ok, solr_error: SolrError.none)
      @header = header
      @http_status = http_status
      @solr_error = solr_error
      freeze
    end

    def ok?
      header.ok?
    end

    def error?
      !ok?
    end

    def status
      header.status
    end

    def error_message
      return if ok?
      solr_error ? solr_error.message : http_status.inspect
    end

    def inspect
      return 'OK' if ok?
      "Error: #{http_status.inspect}\n#{solr_error.inspect}"
    end
  end
end