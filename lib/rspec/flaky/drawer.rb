module Drawer

  class << self
    def draw diffs
      @diffs = diffs
      erb_str  = File.read(Pathes.template_path)
      result = ERB.new(erb_str, nil, '-').result(binding)
      File.open(Pathes.summary_path.join('result.html'), 'w') do |f|
        f.write(result)
      end
      copy_styles
    end

    def prettify(data)
      return 'No data' if data.nil?
      return JSON.pretty_generate(data) if data.is_a? Hash
      data
    end

    def copy_styles
      FileUtils.cp Pathes.assets_path.join('application.css'), Pathes.summary_path
    end
  end

end