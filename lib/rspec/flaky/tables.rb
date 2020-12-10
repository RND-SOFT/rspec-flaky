require 'rspec'
require 'rspec/flaky/dumper/json'
require 'rspec/flaky/dumper/db'

RSpec.configure do |config|
  if ENV["FLAKY_SPEC"] == "1"
    config.before(:suite, table: true) do
      config.after(:each, tables: true) do |example|
        location = example.metadata[:location].gsub('/', ':')
        status = example.exception.nil? ? 'passed' : 'failed'
        tables = Array.wrap(example.metadata[:tables].select{|t| t < ApplicationRecord})

        Dumper::Json.new.dump!(location, status, tables)
        Dumper::Db.new.dump!(location, status, tables)
      end

      config.before(:each, tables: true) do
        DatabaseCleaner.strategy = :truncation
      end
    end
  end
end
