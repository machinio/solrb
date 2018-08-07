module Solr
  class BasicResponse
    class Parser
      def initialize(raw_response)
        @raw_response = raw_response
        @parsed_body = JSON.parse(raw_response.body).freeze
      end

      def parse
        header = parse_header
        http_status = parse_http_status
        solr_error = parse_solr_error
        Solr::BasicResponse.new(header: header, http_status: http_status, solr_error: solr_error)
      end

      private
      
      def parse_header
        parsed_header = @parsed_body['responseHeader']
        status = parsed_header['status'].to_i
        time = parsed_header['QTime'].to_i
        Solr::BasicResponse::Header.new(status: status, time: time)
      end

      def parse_http_status
        HttpStatus.new(status: @raw_response.status, message: @raw_response.reason_phrase)
      end

      def parse_solr_error
        return Solr::BasicResponse::SolrError.none unless @parsed_body['error']
        code = @parsed_body['error']['code'].to_i
        message = @parsed_body['error']['msg']
        Solr::BasicResponse::SolrError.new(code: code, message: message)
      end
    end
  end
end