require 'hashdiff'
require 'fileutils'

module Differ

  EXPECTED_CONTENT = %w(failed.json passed.json)

  class << self
    def get_result
      create_summary_folder
      @diffs = []
      Pathes.summary_path.children.each do |example_dir|
        next unless example_dir.directory?
        next unless example_dir.basename.to_s.start_with?(".:")
        example_dir.children.select do |tables_dir|
          next unless tables_dir.directory?
          @diffs << {
            location: Pathes.relative_path(example_dir),
            table: tables_dir.basename.to_s,
            result: get_diffs(tables_dir)
          }
        end
      end
      Drawer.draw @diffs
    end
  
    def create_summary_folder
      FileUtils.mkdir_p(Pathes.summary_path)
    end

    def get_diffs tables_dir
      return 'no_content' unless contains_passed_and_failed_jsons? tables_dir
      result = []
      jsons = tables_dir.children.select { |child| EXPECTED_CONTENT.include? child.basename.to_s }
      jsons = read_jsons(jsons)
  
      return 'empty_table' if jsons.values.all? &:empty?
      jsons.values.map(&:length).max.times do |idx|
        passed_record = jsons["passed"].try(:[], idx) || {}
        failed_record = jsons["failed"].try(:[], idx) || {}
        result << Hashdiff.diff(passed_record, failed_record)
      end
      result
    end

    def read_jsons pathes
      {}.tap do |hash|
        pathes.each do |path|
          hash[path.basename.to_s.split('.')[0]] = JSON.parse(File.read(Pathes.base_path.join(path)))
        end
      end
    end
  
    def contains_passed_and_failed_jsons? tables_dir
      actual_content = tables_dir.children.map(&:basename).map(&:to_s)
      EXPECTED_CONTENT & actual_content == EXPECTED_CONTENT
    end
  end
  

end