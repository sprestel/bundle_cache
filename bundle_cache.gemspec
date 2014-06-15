# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bundle_cache/version'

Gem::Specification.new do |spec|
  spec.name          = "bundle_cache"
  spec.version       = BundleCache::VERSION
  spec.authors       = ["Sebastian Prestel"]
  spec.email         = ["sebastian.prestel@yahoo.de"]
  spec.description   = %q{Caches bundled gems on dropbox}
  spec.summary       = %q{Speed up your build on Travis CI by caching bundled gems in a dropbox}
  spec.homepage      = "https://github.com/sprestel/bundle_cache"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "dropbox-sdk"
  spec.add_dependency "bundler"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
