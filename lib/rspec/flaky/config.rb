require "ostruct"

module Config
  def self.configure
    yield config
  end

  def self.config
    @config ||= ::OpenStruct.new({
      with_default_output: true,
      default_iterations: 1
    })
  end
end