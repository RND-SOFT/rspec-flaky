require 'json'
require 'fileutils'

module Dumper
  class Json

    def dump!(location, status, tables)
      tables.each do |table|
        return unless table.class < ApplicationRecord
        json = JSON.pretty_generate(table.all.map(&:attributes))
        FileUtils.mkdir_p(dump_path(location, table)) unless File.exists?(dump_path(location, table))
        File.open("#{dump_path(location, table)}/#{status}.json", 'w') do |f|
          f.write(json)
        end
      end
    end

    private

    def dump_path location, table
      "tmp/flaky_tests/#{location}/#{table}"
    end
  end
end