module Solr
  class Configuration
    attr_accessor :field_map, :open_timeout, :read_timeout, :url

    def initialize
      @field_map = {}
      @read_timeout = 2
      @open_timeout = 8
      @url = ENV.fetch('SOLR_URL')
    end

    def uri
      @uri ||= URI.parse(url)
    end
  end
end