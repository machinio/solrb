require 'solr/query/request'
require 'solr/data_import/request'

module Solr
  module Commands
    def update(commands, runner_options: nil)
      request = Solr::Update::Request.new(commands)
      request.run(runner_options: runner_options)
    end

    def commit(wait_searcher: true, optimize: false, runner_options: nil)
      options = { 'waitSearcher' => wait_searcher }

      commands = [Solr::Update::Commands::Commit.new(options)]
      commands << Solr::Update::Commands::Optimize.new(options) if optimize

      update(commands, runner_options: runner_options)
    end

    def delete_by_id(id, commit: false, runner_options: nil)
      commands = [Solr::Update::Commands::Delete.new(id: id)]
      commands << Solr::Update::Commands::Commit.new if commit

      update(commands, runner_options: runner_options)
    end

    def delete_by_query(query, commit: false, runner_options: nil)
      commands = [Solr::Update::Commands::Delete.new(query: query)]
      commands << Solr::Update::Commands::Commit.new if commit

      update(commands, runner_options: runner_options)
    end

    def data_import(params, runner_options: nil)
      request = Solr::DataImport::Request.new(params)
      request.run(runner_options: runner_options)
    end
  end
end
