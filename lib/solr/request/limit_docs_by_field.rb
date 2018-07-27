module Solr
  class Request
    class LimitDocsByField
      include Solr::SchemaHelper
      DEFAULT_PAGE_SIZE = 10
      DEFAULT_LIMIT_PER_PAGE = 2

      attr_reader :field, :min_pages, :page_size, :limit_per_page

      def initialize(field:, min_pages:, page_size: DEFAULT_PAGE_SIZE, limit_per_page: DEFAULT_LIMIT_PER_PAGE)
        @field = field
        @min_pages = min_pages
        @page_size = page_size
        @limit_per_page = limit_per_page
      end

      def to_solr_s
        "{!perPageLimit byField=#{solarize_field(field)} minPages=#{min_pages} pageSize=#{page_size} limitPerPage=#{limit_per_page}}"
      end
    end
  end
end
