# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dgaff_ml/version'

Gem::Specification.new do |spec|
  spec.name          = "dgaff_ml"
  spec.version       = DgaffMl::VERSION
  spec.authors       = ["Devin Gaffney"]
  spec.email         = ["itsme@devingaffney.com"]
  spec.summary       = %q{Interface for API on machinelearning.devingaffney.com}
  spec.description   = %q{Interface for API on machinelearning.devingaffney.com}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rest-client", "~> 2.0.2"
  spec.add_development_dependency "fast-stemmer", "~> 1.0.2"
end
