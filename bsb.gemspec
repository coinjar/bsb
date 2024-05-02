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
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.7.7'

  spec.add_dependency 'activemodel'

  # N.B. needed for periodic auto update of database.
  #
  # rubocop:disable Gemspec/RequireMFA
  spec.metadata['rubygems_mfa_required'] = 'false'
  # rubocop:enable Gemspec/RequireMFA
end
