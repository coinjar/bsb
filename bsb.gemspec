# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bsb/version'

Gem::Specification.new do |spec|
  spec.name          = 'bsb'
  spec.version       = BSB::VERSION
  spec.authors       = ['Ryan Zhou']
  spec.email         = ['git@zhoutong.com']
  spec.summary       = 'BSB number validator with built-in database.'
  spec.description   = 'BSB number validator with built-in database.'
  spec.homepage      = 'https://github.com/zhoutong/bsb'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'webmock'
  spec.add_dependency 'activemodel'
end
