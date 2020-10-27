require 'rspec'
require 'rspec/flaky/dumper/json'
require 'rspec/flaky/dumper/db'

RSpec.configure do |config|
  config.after(:each) do |example|
    return unless example.metadata[:tables].present?
    
    location = example.metadata[:location].gsub('/', '_')
    status = example.exception.nil? ? 'passed' : 'failed'
    tables = Array.wrap(example.metadata[:tables])

    Dumper::Json.new.dump!(location, status, tables)
    Dumper::Db.new.dump!(location, status, tables)
  end
end
