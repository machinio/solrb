# encoding: UTF-8

RSpec.describe Solr::Support::StringExtensions do
  using Solr::Support::StringExtensions

  describe '.solr_escape' do
    it "adds backslash to Solr query syntax chars" do
      # per http://lucene.apache.org/core/4_0_0/queryparser/org/apache/lucene/queryparser/classic/package-summary.html#Escaping_Special_Characters
      special_chars = [ "+", "-", "&", "|", "!", "(", ")", "{", "}", "[", "]", "^", '"', "~", "*", "?", ":", "\\", "/" ]
      escaped_str = "aa#{special_chars.join('aa')}aa".solr_escape
      special_chars.each { |c|
        # note that the ruby code sending the query to Solr will un-escape the backslashes
        # so the result sent to Solr is ultimately a single backslash in front of the particular character
        expect(escaped_str).to match "\\#{c}"
      }
    end

    it "leaves other chars alone" do
      str = "nothing to see here; let's move along people."
      expect(str.solr_escape).to eq str
    end
  end
end
