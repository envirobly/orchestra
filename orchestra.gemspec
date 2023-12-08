require_relative "lib/orchestra/version"

Gem::Specification.new do |spec|
  spec.name        = "orchestra"
  spec.version     = Orchestra::VERSION
  spec.authors     = ["Robert Starsi"]
  spec.email       = "klevo@klevo.sk"
  spec.homepage    = "https://github.com/SiliconSail/orchestra"
  spec.summary     = "Envirobly container orchestration agent with zero downtime deployments."
  spec.license     = "MIT"

  spec.files = Dir["lib/**/*", "LICENSE"]
  spec.executables = %w[orchestra]

  spec.add_dependency "activesupport", "~> 7.0"
  spec.add_dependency "thor", "~> 1.3"
  spec.add_dependency "zeitwerk", "~> 2.6"
  spec.add_dependency "httpx", "~> 1.1"
  # spec.add_dependency "aws-sdk-s3", "~> 1.141"

  # TODO: @deprecated Replace with httpx completely
  spec.add_dependency "httparty", "~> 0.21"

  spec.add_development_dependency "debug", "~> 1.8"
end
