require 'rspec/flaky/config'
require 'rspec/flaky/version'
require 'rspec/flaky/differ'
require 'rspec/flaky/tables'
require 'rspec/flaky/pathes'
require 'rspec/flaky/drawer'
require 'rspec'
require 'fileutils'

class RSpec::Flaky

  def run_spec locations, options
    FileUtils.rm_rf(Pathes.summary_path)
    rspec_options = options.delete(:rspec_options) || ""
    (options[:iterations] || Config.config.default_iterations).times do
      if Config.config.with_default_output
        system("FLAKY_SPEC=1 rspec #{locations} #{rspec_options}")
      else
        output, status = Open3.capture2e("FLAKY_SPEC=1 rspec #{locations} #{rspec_options}")
      end
    end
    Differ.get_result
    Pathes.summary_path.children.each { |child| FileUtils.rm_rf(child) if child.directory? } 
  end

end