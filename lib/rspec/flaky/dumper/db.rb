require 'rails'

module Dumper
  class Db

    def dump!(location, status, tables)
      tables.each do |table|
        path = dump_path(location, table)
        FileUtils.mkdir_p(path) unless File.exists?(path)
        #TODO adapter for mysql and sqlite3
        #TODO username from config
        system "pg_dump -U postgres -d #{db_name} > #{path}/#{status}.sql"
      end
    end

    private

    def db_name
      Rails.configuration.database_configuration["test"]["database"]
    end

    def dump_path location, table
      "tmp/flaky_tests/#{location}/#{table}"
    end

  end
end