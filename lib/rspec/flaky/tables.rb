require 'rspec'
require 'json'
require 'fileutils'

RSpec.configure do |config|
  config.after(:each) do |example|
    if example.metadata[:tables].present?
      status = example.exception.nil? ? 'passed' : 'failed'
      tables = Array.wrap(example.metadata[:tables])
      tables.each do |table|
        json = JSON.pretty_generate(table.all.map(&:attributes))
        FileUtils.mkdir_p("tmp/flaky_tests/#{table}") unless File.exists?("tmp/flaky_tests/#{table}")
        File.open("tmp/flaky_tests/#{table}/#{status}.json", 'w') do |f|
          f.write(json)
        end
      end
    end
  end
end
