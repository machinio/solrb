module Solr
  module Indexing
    class Request
      # TODO: potentially make handlers configurable and have them handle the path
      PATH = '/update'.freeze
      def initialize(docs)
        @docs = docs
      end

      def run
        binding.pry
        connection.post_as_json(@docs)
      end


      private

      def connection
        @connection ||= begin
          binding.pry
          base_uri = URI.parse(Solr.configuration.url)
          full_path = File.join(base_uri.path, PATH)
          full_uri = URI.join(base_uri, full_path)
          Solr::Connection.new(full_uri)
        end
      end
    end
  end
end