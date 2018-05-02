# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "codecal/version"

Gem::Specification.new do |spec|
  spec.name          = "codecal"
  spec.version       = Codecal::VERSION
  spec.authors       = ["Roger Fang"]
  spec.email         = ["roger.fang@blockchaintech.net.au"]

  spec.summary       = %q{calculate a string for parameters.}
  spec.description   = %q{return a string according to parameters(1/2) and a seed.}
  spec.homepage      = "https://github.com/roger-fang-bct/codecal.git"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
