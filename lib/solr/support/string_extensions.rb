module Solr
  module StringExtensions
    refine String do
      # REVIEW: this escape
      def solr_escape
        gsub(/([+\-&|!\(\)\{\}\[\]\^"~\*\?:\\\/])/, '\\\\\1')
      end
    end
  end
end
