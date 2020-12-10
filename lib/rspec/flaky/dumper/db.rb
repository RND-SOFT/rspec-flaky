require 'rails'

module Dumper
  class Db

    def dump!(location, status)
      path = dump_path(location)
      FileUtils.mkdir_p(path) unless File.exists?(path)
      #TODO adapter for mysql and sqlite3
      #TODO username from config
      system "pg_dump -U postgres -d #{db_name} > #{path}/#{status}.sql"
    end

    private

    def db_name
      Rails.configuration.database_configuration["test"]["database"]
    end

    def dump_path location
      "tmp/flaky_tests/database_dumps/#{location}"
    end

  end
end