require 'rspec/flaky/config'
require 'rspec/flaky/version'
require 'rspec/flaky/tables'
require 'rspec'

class RSpec::Flaky

  def run_spec locations, options
    rspec_options = options.delete(:rspec_options) || ""
    options[:iterations].times do
      if Config.config.with_default_output
        system("rspec #{locations} #{rspec_options}")
      else
        output, status = Open3.capture2e("rspec #{locations} #{rspec_options}")
      end
    end
  end

end