require_relative 'lib/neo_gruby/version'

Gem::Specification.new do |spec|
  spec.name          = "neo_gruby"
  spec.version       = NeoGruby::VERSION
  spec.authors       = ["Welington Sampaio"]
  spec.email         = ["welington@gruponeolife.com.br"]

  spec.summary       = %q{Little ruby framework to works with GRPC}
  # spec.description   = %q{}
  spec.homepage      = "https://github.com/neolifehq/neogruby"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # spec.metadata["allowed_push_host"] = "Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/neolifehq/neogruby.git"
  # spec.metadata["changelog_uri"] = "https://github.com/neolifehq/neogruby/changelog"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir['lib/**/*.rb', 'exe/*']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'grpc', '~> 1.26.0'
  spec.add_dependency 'dotenv', '~> 2.7.5'
  spec.add_dependency 'dry-cli', '~> 0.5.1'
  spec.add_dependency 'logger', '~> 1.4.0'
  spec.add_dependency 'pry', '~> 0.12.2'
end
