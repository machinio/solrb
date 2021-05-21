lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'solr/version'

Gem::Specification.new do |spec|
  spec.name          = 'solrb'
  spec.version       = Solr::VERSION
  spec.authors       = ['Adriano Luz', 'Valentin Vasilyev', 'Vladislav Syabruk']
  spec.email         = ['adriano.luz@machinio.com', 'valentin@machinio.com', 'vladislav.syabruk@machinio.com']

  spec.summary       = 'Solr Ruby client with a nice object-oriented API'
  spec.homepage      = 'https://github.com/machinio/solrb'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'addressable'
  spec.add_runtime_dependency 'faraday'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.80.1'
  spec.add_development_dependency 'simplecov'
end
