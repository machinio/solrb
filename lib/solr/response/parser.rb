module Solr
  class Response
    class Parser
      def self.call(raw_response)
        new(raw_response).call
      end

      def initialize(raw_response)
        @raw_response = raw_response
      end

      def call
        # 404 is a special case, it didn't hit Solr (more likely than not)
        return not_found_response if @raw_response.status == 404
        parsed_body = @raw_response.body ? JSON.parse(@raw_response.body).freeze : {}
        http_status = parse_http_status
        header = parse_header(parsed_body)
        solr_error = parse_solr_error(parsed_body)
        Solr::Response.new(header: header, http_status: http_status, solr_error: solr_error, body: parsed_body)
      end

      private

      def not_found_response
        Solr::Response.new(
          header: Solr::Response::Header.new(status: 404),
          http_status: Solr::Response::HttpStatus.not_found,
          solr_error: nil
        )
      end

      def parse_header(parsed_body)
        if response_header = parsed_body['responseHeader']
          status = response_header['status'].to_i
          time = response_header['QTime'].to_i
          Solr::Response::Header.new(status: status, time: time)
        elsif response_header = parsed_body['error']
          status = response_header['code'].to_i
          Solr::Response::Header.new(status: status)
        end
      end

      def parse_http_status
        HttpStatus.new(status: @raw_response.status, message: @raw_response.reason_phrase)
      end

      def parse_solr_error(parsed_body)
        return Solr::Response::SolrError.none unless parsed_body['error']
        code = parsed_body['error']['code'].to_i
        message = parsed_body['error']['msg']
        Solr::Response::SolrError.new(code: code, message: message)
      end
    end
  end
end
