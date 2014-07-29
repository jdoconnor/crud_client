# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require File.expand_path('../lib/crud_client/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "crud_client"
  spec.version       = CrudClient::VERSION
  spec.authors       = ["Jay OConnor"]
  spec.email         = ["jay@bellycard.com"]
  spec.description   = %q{Easy connections to APIs}
  spec.summary       = %q{Easy connections to APIs}
  spec.homepage      = ""
  spec.license       = ""

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday_middleware'
  spec.add_dependency 'hashie'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'celluloid'
  spec.add_dependency 'celluloid-io'
  spec.add_dependency 'imprint'
  spec.add_dependency 'napa'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'git'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'simplecov'
end
