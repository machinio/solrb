require 'solr/response/header'
require 'solr/response/http_status'
require 'solr/response/solr_error'
require 'solr/response/parser'

module Solr
  class Response
    OK = 'OK'.freeze

    def self.from_raw_response(response)
      Solr::Response::Parser.new(response).parse
    end

    attr_reader :header, :http_status, :solr_error, :body

    def initialize(header:, http_status: HttpStatus.ok, solr_error: SolrError.none, body: {})
      @header = header
      @http_status = http_status
      @solr_error = solr_error
      @body = body
      freeze
    end

    def ok?
      header.ok?
    end

    def error?
      !ok?
    end

    def status
      if header.status.zero?
        OK
      else
        header.status
      end
    end

    def error_message
      return if ok?
      solr_error ? solr_error.message : http_status.inspect
    end

    def inspect
      return OK if ok?
      str = "Error: #{http_status.inspect}"
      str << "\n#{solr_error.inspect}" if solr_error
      str
    end
  end
end
