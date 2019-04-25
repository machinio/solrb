module Solr
  module HelperMethods
    def active_nodes_for(collection:)
      if cloud_enabled?
        cloud_active_nodes_for(collection: collection)
      elsif master_slave_enabled?
        master_slave_active_nodes_for(collection: collection)
      end
    end
  end
end
