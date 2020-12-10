module Drawer

  class << self
    def draw diffs
      @diffs = diffs
      erb_str  = File.read(Pathes.template_path)
      result = ERB.new(erb_str, nil, '-').result(binding)
      File.open(Pathes.summary_path.join('result.html'), 'w') do |f|
        f.write(result)
      end
    end

    def prettify(data)
      return '-' if data.nil?
      return JSON.pretty_generate(data) if data.is_a? Hash
      data
    end

  end

end