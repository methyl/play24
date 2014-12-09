# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'play24/version'

Gem::Specification.new do |spec|
  spec.name          = "play24"
  spec.version       = Play24::VERSION
  spec.authors       = ["Lucjan Suski"]
  spec.email         = ["lucjansuski@gmail.com"]
  spec.summary       = %q{Client for https://24.play.pl}
  spec.homepage      = "https://github.com/methyl/play24"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "mechanize", "~> 2.7"
end
