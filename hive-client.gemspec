# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hive/client/version'

Gem::Specification.new do |spec|
  spec.name          = "hive-client"
  spec.version       = Hive::Client::VERSION
  spec.authors       = ["Andy Lindeman"]
  spec.email         = ["andy@andylindeman.com"]
  spec.description   = %q{Barebones client for making Hive queries from Ruby}
  spec.summary       = %q{Barebones client for making Hive queries from Ruby}
  spec.homepage      = "https://github.com/alindeman/hive-client"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "msgpack", "~>0.5.6"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~>2.14"
end
