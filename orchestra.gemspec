require_relative "lib/orchestra/version"

Gem::Specification.new do |spec|
  spec.name        = "orchestra"
  spec.version     = Orchestra::VERSION
  spec.authors     = ["Robert Starsi"]
  spec.email       = "klevo@klevo.sk"
  spec.homepage    = "https://github.com/SiliconSail/orchestra"
  spec.summary     = "SiliconSail container orchestration agent with zero downtime deployments."
  spec.license     = "Copyright 2023 Robert Starsi. All rights reserved."

  spec.files = Dir["lib/**/*", "LICENSE"]
  spec.executables = %w[orchestra]

  # spec.add_dependency "activesupport", ">= 7.0"
  spec.add_dependency "thor"
  spec.add_dependency "zeitwerk"
  spec.add_dependency "httparty"

  spec.add_development_dependency "debug"
  # spec.add_development_dependency "railties"
end
