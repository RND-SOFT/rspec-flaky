require 'rspec/flaky'
require 'optparse'

module Flaky
  class CLI

    def run argv
      locations = argv.shift
      options = parse_options(argv)
      options[:rspec_options] = extract_rspec_options argv
      RSpec::Flaky.new.run_spec(locations, options)
    end
  
    private
  
    def parse_options argv
      options = {}
      OptionParser.new do |opts|
        opts.banner = "Usage: rspec-flaky path/to/flaky_spec.rb:12 [options] -- [rspec options]"
      
        opts.on("-i", "--iterations [NUMBER]", Integer, "Execute spec a given number of times")  do |v|
          options[:iterations] = v || 1
        end
      
        opts.on('-h', '--help', 'Displays Help') do
          puts opts
          exit
        end
      end.parse!(argv)
      options
    end
  
    def extract_rspec_options argv
      idx = argv.index('--') || -1
      rspec_options = argv[idx+1..-1]
      return if rspec_options.empty?
      rspec_options.compact.join(' ')
    end
  end
end