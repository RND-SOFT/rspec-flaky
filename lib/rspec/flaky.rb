require 'rspec/flaky/version'
require 'rspec/flaky/differ'
require 'rspec/flaky/tables'
require 'rspec/flaky/pathes'
require 'rspec/flaky/drawer'
require 'rspec'
require 'fileutils'
require 'open3'

module RSpec::Flaky

  def self.run_spec locations, options
    FileUtils.rm_rf(Pathes.summary_path)
    rspec_options = options.delete(:rspec_options) || ""
    options[:iterations].times do
      if options[:silent]
        Open3.capture2e("FLAKY_SPEC=1 rspec #{locations} #{rspec_options}")
      else
        system("FLAKY_SPEC=1 rspec #{locations} #{rspec_options}")
      end
    end
    Differ.get_result 
    Pathes.summary_path.children.each do |child|
      if child.basename.to_s.start_with?(".:")
        FileUtils.rm_rf(child) unless options[:save_jsons]
      elsif child.basename.to_s == 'database_dumps'
        FileUtils.rm_rf(child) unless options[:dump_db]
      end
    end
  end

end