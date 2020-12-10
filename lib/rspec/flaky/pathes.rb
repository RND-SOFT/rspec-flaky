module Pathes

  class << self

    def template_path
      assets_path.join("layout.html.erb")
    end

    def summary_path
      base_path.join('tmp/flaky_tests')
    end

    def base_path
      Pathname.new(FileUtils.pwd)
    end
  
    def relative_path path
      path.relative_path_from(summary_path).to_s
    end

    def assets_path
      Pathname.new(__dir__).join("../../../assets/")
    end

  end

end