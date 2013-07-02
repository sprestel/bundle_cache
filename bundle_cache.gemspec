# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bundle_cache/version'

Gem::Specification.new do |spec|
  spec.name          = "bundle_cache"
  spec.version       = BundleCache::VERSION
  spec.authors       = ["Eric Barendt"]
  spec.email         = ["eric.barendt@infogroup.com"]
  spec.description   = %q{Caches bundled gems on S3}
  spec.summary       = %q{Caches bundled gems on S3}
  spec.homepage      = ""
  spec.license       = "Proprietary"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "fog"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
