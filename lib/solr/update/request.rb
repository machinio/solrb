require 'solr/update/commands/add'
require 'solr/update/commands/delete'
require 'solr/update/commands/commit'
require 'solr/update/commands/optimize'

module Solr
  module Update
    class Request
      PATH = '/update/json'.freeze

      attr_reader :commands

      def initialize(commands = [])
        @commands = commands
      end

      def run(commit: false, runner_options: nil)
        http_request = build_http_request(commit)
        options = default_runner_options.merge(runner_options || {})
        Solr::Request::Runner.call(request: http_request, **options)
      end

      private

      def default_runner_options
        if Solr.cloud_enabled?
          { node_selection_strategy: Solr::Request::Cloud::LeaderNodeSelectionStrategy }
        elsif Solr.master_slave_enabled?
          { node_selection_strategy: Solr::Request::MasterSlave::MasterNodeSelectionStrategy }
        else
          {}
        end
      end

      def build_http_request(commit)
        Solr::Request::HttpRequest.new(path: PATH, body: body, url_params: { commit: commit }, method: :post)
      end

      def body
        commands.group_by(&:class).reduce({}) do |acc, (command_class, commands_group)|
          acc[command_class::COMMAND_KEY] = commands_group.count > 1 ? commands_group : commands_group.first
          acc
        end
      end
    end
  end
end
