module RSpecFlaky
  def self.configure
    yield config
  end

  def self.config
    @config ||= OpenStruct.new({
      with_default_output:  true
    })
  end
end