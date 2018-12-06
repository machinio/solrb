module Solr
  module Commands
    def commit
      Solr::Commit::Request.new.run
    end

    def delete_by_id(id, commit: false)
      Solr::Delete::Request.new(id: id).run(commit: commit)
    end

    def delete_by_query(query, commit: false)
      Solr::Delete::Request.new(query: query).run(commit: commit)
    end

    def data_import(params)
      Solr::DataImport::Request.new(params).run
    end
  end
end
