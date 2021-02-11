$:.push File.expand_path('lib', __dir__)
require 'rspec/flaky/version'

Gem::Specification.new 'rspec-flaky' do |spec|
  spec.version     = RSpecFlaky::VERSION
  spec.authors     = ['maratz']
  spec.email       = ['mzasorinwd@gmail.com']
  spec.homepage    = 'https://github.com/RND-SOFT/rspec-flaky'

  spec.summary     = 'Gem for catching flaky specs'
  spec.description = 'Gem wraps every runned example to dump pointed database tables to json files'

  spec.license     = 'MIT'

  spec.files       = Dir['{lib}/**/*', "{bin}/*", "{assets}/*", 'README.md', 'LICENSE"'].reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.test_files = Dir['**/*'].select do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'bin'
  spec.executables   = 'rspec-flaky'

  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'hashdiff', '~> 1.0.1'
end

