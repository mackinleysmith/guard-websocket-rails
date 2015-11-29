# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'guard/websocket-rails/version'

Gem::Specification.new do |spec|
  spec.name          = "guard-websocket-rails"
  spec.version       = Guard::WebsocketRails::VERSION
  spec.authors       = ["MacKinley Smith"]
  spec.email         = ["smit1625@msu.edu"]

  spec.summary       = %q{Guard::WebsocketRails allows you to automatically start and stop your websocket-rails standalone server.}
  spec.description   = %q{Guard::WebsocketRails allows you to automatically start and stop your websocket-rails standalone server.}
  spec.homepage      = "https://github.com/smit1625/guard-websocket-rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'guard'
  # spec.add_development_dependency "bundler", "~> 1.10"
  # spec.add_development_dependency "rake", "~> 10.0"
end
