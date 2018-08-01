module Solr
  class BasicResponse
    def self.from_raw_response(json)
      raw_response = JSON.parse(json)
      raw_status = raw_response['responseHeader']['status'].to_i
      # TODO: see what statuses solr can return
      status = raw_status.zero? ? :OK : raw_status
      time = raw_response['responseHeader']['QTime'].to_i
      new(status: status, time: time)
    end

    attr_reader :status, :time

    def initialize(status:, time: 0)
      @status = status
      @time = time
    end
  end
end