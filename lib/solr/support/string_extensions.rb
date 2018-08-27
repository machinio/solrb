module Solr
  module Support
    module StringExtensions
      refine String do
        # REVIEW: this escape
        def solr_escape
          gsub(%r(([+\-&|!\(\)\{\}\[\]\^"~\*\?:\\/])), '\\\\\1')
        end
      end
    end
  end
end
