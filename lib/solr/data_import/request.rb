require 'solr/request/first_shard_leader_node_selection_strategy'

module Solr
  module DataImport
    class Request
      PATH = '/dataimport'.freeze

      attr_reader :params

      def initialize(params)
        @params = params
      end

      # We want to make sure we send every dataimport request to the same node because this same class
      # could be used to start a dataimport and to get dataimport progress data afterwards.
      # To make it consistent we will send dataimport requests only to the first shard leader replica
      def run
        http_request = Solr::Request::HttpRequest.new(path: PATH, url_params: params, method: :get)
        Solr::Request::Runner.call(request: http_request, node_selection_strategy: build_node_selection_strategy)
      end

      def build_node_selection_strategy
        Solr::Request::FirstShardLeaderNodeSelectionStrategy
      end
    end
  end
end
