# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pili/version'

Gem::Specification.new do |spec|
  spec.name          = "piliv2"
  spec.version       = Pili::VERSION
  spec.authors       = ["Pili Engineer"]
  spec.email         = ["pili@qiniu.com"]
  spec.summary       = %q{Pili Streaming Cloud Server-Side Library For Ruby.}
  spec.description   = %q{Pili Streaming Cloud Server-Side Library For Ruby. Quick setup, fast play.}
  spec.homepage      = "https://github.com/pili-engineering/pili-sdk-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", '~> 1.7'
  spec.add_development_dependency "rake",  '~> 10.0'
end
