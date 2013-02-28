# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'engrade-ruby/version'

Gem::Specification.new do |gem|
  gem.name          = "engrade-ruby"
  gem.version       = EngradeRuby::VERSION
  gem.authors       = ["Zachary Thompson"]
  gem.email         = ["zgthompson@gmail.com"]
  gem.description   = %q{Basic ruby wrapper for the Engrade API}
  gem.summary       = %q{Utilize the Engrade API easily through Ruby}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'httparty'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'turn'
  gem.add_development_dependency 'rake'
end
