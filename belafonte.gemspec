# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'belafonte/version'

Gem::Specification.new do |spec|
  spec.name          = "belafonte"
  spec.version       = Belafonte::VERSION
  spec.authors       = ["Dennis Walters"]
  spec.email         = ["dwalters@engineyard.com"]

  spec.summary       = %q{Jump in the command line!}
  spec.homepage      = "https://github.com/ess/belafonte"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
