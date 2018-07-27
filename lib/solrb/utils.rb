module Solrb
  module Utils
    class << self
      def solr_escape(str)
        str.gsub(/([+\-&|!\(\)\{\}\[\]\^"~\*\?:\\\/])/, '\\\\\1')
      end
    end
  end
end
