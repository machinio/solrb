module Solr
  module HashExtensions
    extend self
  
    def symbolize_recursive(hash)
      {}.tap do |h|
        hash.each { |key, value| h[key.to_sym] = transform(value) }
      end
    end
  
    private
  
    def transform(thing)
      case thing
      when Hash; symbolize_recursive(thing)
      when Array; thing.map { |v| transform(v) }
      else; thing
      end
    end
  
    refine Hash do
      def deep_symbolize_keys
        HashExtensions.symbolize_recursive(self)
      end
    end
  end
end