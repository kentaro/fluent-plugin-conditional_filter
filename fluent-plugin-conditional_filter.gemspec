# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'fluent-plugin-conditional_filter'
  spec.version       = '0.0.4'
  spec.authors       = ['Kentaro Kuribayashi']
  spec.email         = ['kentarok@gmail.com']
  spec.description   = %q{A fluent plugin that provides conditional filters}
  spec.summary       = %q{A fluent plugin that provides conditional filters}
  spec.homepage      = 'http://github.com/kentaro/fluent-plugin-conditional_filter'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'fluentd', [">= 0.14.0", "< 2"]

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'test-unit'
end
