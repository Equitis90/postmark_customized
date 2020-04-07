lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "griddler/postmark_customized/version"

Gem::Specification.new do |spec|
  spec.name          = "postmark_customized"
  spec.version       = Griddler::PostmarkCustomized::VERSION
  spec.authors       = ["Vladyslav Sydorenko"]
  spec.email         = ["svuitis@gmail.com"]

  spec.summary       = %q{Customized Postmark adapter for Griddler}
  spec.description   = %q{Allows to accept MailboxHash from Postmark response}
  spec.homepage      = "https://github.com/Equitis90/postmark_customized_adapter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "griddler"
end
