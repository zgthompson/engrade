# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'engrade/version'

Gem::Specification.new do |gem|
  gem.name          = "engrade"
  gem.version       = Engrade::VERSION
  gem.authors       = ["Zachary Thompson"]
  gem.email         = ["zgthompson@gmail.com"]
  gem.description   = %q{Basic ruby wrapper for the Engrade API}
  gem.summary       = %q{Utilize the Engrade API easily through Ruby}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'rest-client'
  gem.add_runtime_dependency 'mechanize'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'factory_girl'
  gem.add_development_dependency 'rb-inotify'
end
