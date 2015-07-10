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
  spec.description   = %q{Wrapper for idealista.com API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
