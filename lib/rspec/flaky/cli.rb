require 'rspec/flaky'
require 'optparse'

module Flaky
  class CLI

    DEFAULT_OPTIONS = {
      iterations: 10,
      silent: false,
      save_jsons: false,
      dump_db: false
    }

    def run argv
      locations = get_location(argv) unless argv.any?{|arg| arg == '-h' || arg == '--help'}
      options = parse_options(argv).reverse_merge(DEFAULT_OPTIONS)
      options[:rspec_options] = extract_rspec_options argv
      RSpec::Flaky.run_spec(locations, options)
    end
  
    private
  
    def get_location(argv)
      first_arg = argv.shift
      raise 'You need to specify location first' unless Pathname.new(first_arg.split(":").first).exist?
      return first_arg
    end

    
    def parse_options argv
      options = {}
      OptionParser.new do |opts|
        opts.banner = "Usage: rspec-flaky path/to/flaky_spec.rb:12 [options] -- [rspec options]"
      
        opts.on("-i", "--iterations [NUMBER]", Integer, "Execute spec a given number of times")  do |v|
          options[:iterations] = v
        end

        opts.on("--silent", "Silent mode (no output)") do |v|
          options[:silent] = v 
        end
        opts.on("-j", "--jsons", "Save pointed models attributes")  do |v|
          options[:save_jsons] = v
        end
        opts.on("-d", "--dump", "Dump database to sql-file after each example")  do |v|
          options[:dump_db] = v
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