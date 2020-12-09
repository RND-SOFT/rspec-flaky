require 'hashdiff'
require 'fileutils'
require 'rails'

module Differ

  EXPECTED_CONTENT = %w(failed.json passed.json)

  class << self
    def get_result
      create_summary_folder
      @diffs = []
      summary_path.children.select do |example_dir|
        next unless example_dir.directory?
        example_dir.children.select do |tables_dir|
          next unless tables_dir.directory?
          @diffs << if contains_passed_and_failed_jsons? tables_dir
            {
              location: relative_path(example_dir),
              table: tables_dir.basename.to_s,
              result: get_diffs(tables_dir)
            }
          else
            {
              location: relative_path(example_dir),
              table: tables_dir.basename.to_s,
              result: 'no_content'
            }
          end
        end
      end
      generate_html
    end
  
    def prettify(kek)
      return 'No data' if kek.nil?
      return JSON.pretty_generate(kek) if kek.is_a? Hash
      kek
    end
  
    def generate_html
      erb_str  = File.read(template_path)
      result = ERB.new(erb_str, nil, '-').result(binding)
      File.open(summary_path.join('result.html'), 'w') do |f|
        f.write(result)
      end
    end

    def create_summary_folder
      FileUtils.mkdir_p(summary_path)
    end

    def summary_path
      base_path.join('tmp/flaky_tests')
    end

    def base_path
      Pathname.new(FileUtils.pwd)
    end
  
    def template_path
      Pathname.new(__dir__).join("./layout.html.erb")
    end
  
    def relative_path path
      path.relative_path_from(summary_path).to_s
    end
  
    def get_diffs tables_dir
      result = []
      jsons = tables_dir.children.select { |child| EXPECTED_CONTENT.include? child.basename.to_s }
      jsons = read_jsons(jsons)
  
      jsons.values.map(&:length).max.times do |idx|
        passed_record = jsons["passed"][idx]
        failed_record = jsons["failed"][idx]
        result << Hashdiff.diff(passed_record, failed_record)
      end
      result
    end
  
    def read_jsons pathes
      {}.tap do |hash|
        pathes.each do |path|
          hash[path.basename.to_s.split('.')[0]] = JSON.parse(File.read(base_path.join(path)))
        end
      end
    end
  
    def contains_passed_and_failed_jsons? tables_dir
      actual_content = tables_dir.children.map(&:basename).map(&:to_s)
      EXPECTED_CONTENT & actual_content == EXPECTED_CONTENT
    end
  end
  

end