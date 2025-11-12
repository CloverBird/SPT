Gem::Specification.new do |spec|
  spec.name = "contacts_utils"
  spec.version = "0.1.0"

  spec.summary = "Email & phone validation and normalization helpers."
  spec.description = "A small Ruby gem for validation and normalization of email addresses and phone numbers."
  spec.authors = ["CloverBird"]

  spec.files = Dir["lib/**/*", "README*", "LICENSE*", "examples/demo.rb"]

  spec.required_ruby_version = ">= 3.0"

  spec.add_development_dependency "rspec", "~> 3.13"
end