module Solr
  module StringExtensions
    refine String do
      # review this escape
      def solr_escape
        self.gsub(/([+\-&|!\(\)\{\}\[\]\^"~\*\?:\\\/])/, '\\\\\1')
      end
    end
  end
end
