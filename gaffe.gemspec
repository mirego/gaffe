# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gaffe/version'

Gem::Specification.new do |spec|
  spec.name          = 'gaffe'
  spec.version       = Gaffe::VERSION
  spec.authors       = ['Rémi Prévost', 'Simon Prévost']
  spec.email         = ['rprevost@mirego.com', 'sprevost@mirego.com']
  spec.description   = 'Gaffe handles Rails error pages in a clean, simple way.'
  spec.summary       = 'Gaffe handles Rails error pages in a clean, simple way.'
  spec.homepage      = 'https://github.com/mirego/gaffe'
  spec.license       = "BSD 3-Clause"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'coveralls'

  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'scss-lint'
  spec.add_development_dependency 'phare'

  spec.add_dependency 'rails', '>= 3.2.0'
end
