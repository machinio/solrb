require 'solr/delete/request'
require 'solr/commit/request'
require 'solr/query/request'
require 'solr/data_import/request'

module Solr
  module Commands
    def commit(open_searcher: true, optimize: false, runner_options: nil)
      Solr::Commit::Request.new.run(optimize: optimize,
                                    open_searcher: open_searcher,
                                    runner_options: runner_options)
    end

    def delete_by_id(id, commit: false, runner_options: nil)
      request = Solr::Delete::Request.new(id: id)
      request.run(commit: commit, runner_options: runner_options)
    end

    def update(commands, commit: false, runner_options: nil)
      request = Solr::Update::Request.new(commands)
      request.run(commit: commit, runner_options: runner_options)
    end

    def delete_by_query(query, commit: false, runner_options: nil)
      request = Solr::Delete::Request.new(query: query)
      request.run(commit: commit, runner_options: runner_options)
    end

    def data_import(params, runner_options: nil)
      request = Solr::DataImport::Request.new(params)
      request.run(runner_options: runner_options)
    end
  end
end
