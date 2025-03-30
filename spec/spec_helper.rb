if ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.start do
    add_filter '/spec/'
    track_files 'lib/**/*.rb'
  end
end

require 'bundler/setup'
require 'pry'
require 'securerandom'
require 'solr'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    # if ENV['SOLR_MASTER_URL'] && ENV['SOLR_SLAVE_URL']
    #   Solr.conS
    #   Solr.configuration = Solr::Configuration.new
    #   Solr.enable_master_slave!
    # end
    Solr.configure do |config|
      if ENV['SOLR_MASTER_URL'] && ENV['SOLR_SLAVE_URL']
        config.master_url = ENV['SOLR_MASTER_URL']
        config.slave_url = ENV['SOLR_SLAVE_URL']
      end

      if ENV['SOLR_URL']
        config.url = ENV['SOLR_URL']
      end
    end
  end

  # config.after(:each) do
  #   Solr.configuration = Solr::Configuration.new
  # end
end
