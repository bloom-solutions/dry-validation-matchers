# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dry/validation/matchers/version'

Gem::Specification.new do |spec|
  spec.name          = "dry-validation-matchers"
  spec.version       = Dry::Validation::Matchers::VERSION
  spec.authors       = ["Ramon Tayag"]
  spec.email         = ["ramon.tayag@gmail.com"]

  spec.summary       = %q{RSpec matchers for dry-validation}
  spec.description   = %q{RSpec matchers for dry-validation}
  spec.homepage      = "https://github.com/imacchiato/dry-validation-matchers"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "dry-validation", "~> 1.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
end
