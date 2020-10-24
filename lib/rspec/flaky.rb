require 'rspec/flaky/config'
require 'rspec/flaky/version'

class RSpec::Flaky

  def run_spec locations, options
    rspec_options = options.delete(:rspec_options) || ""
    options[:iterations].times do
      if RSpecFlaky.config.with_default_output
        puts "rspec #{locations} #{rspec_options}"
        system("rspec #{locations} #{rspec_options}")
      else
        output, status = Open3.capture2e("rspec #{locations} #{rspec_options}")
      end
    end
  end

end