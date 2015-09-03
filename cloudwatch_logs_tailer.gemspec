# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cloudwatch_logs_tailer/version'

Gem::Specification.new do |spec|
  spec.name          = "cloudwatch_logs_tailer"
  spec.version       = CloudwatchLogsTailer::VERSION
  spec.authors       = ["Marcin Ciszak"]
  spec.email         = ["marcin@state.com"]
  spec.description   = %q{CloudwatchLogs tailer}
  spec.summary       = %q{CloudwatchLogs tailer}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk", "~> 2.0"
  spec.add_dependency "chronic"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
