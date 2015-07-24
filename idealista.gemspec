# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'idealista/version'

Gem::Specification.new do |spec|
  spec.name          = "idealista"
  spec.version       = Idealista::VERSION
  spec.authors       = ["Marko Lovic"]
  spec.email         = ["markolovic@hotmail.com"]
  spec.summary       = %q{Wrapper for idealista.com API}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/markolovic/idealista"
  spec.license       = "MIT"

  spec.files = %w(LICENSE.md README.md idealista.gemspec) + Dir['lib/**/*.rb']
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.13"
  spec.add_development_dependency "bundler", "~> 1.7"
end
