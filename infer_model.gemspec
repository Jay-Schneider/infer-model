# frozen_string_literal: true

require_relative "lib/infer_model/version"

Gem::Specification.new do |spec|
  spec.name = "infer_model"
  spec.version = InferModel::VERSION
  spec.authors = ["Jay Schneider"]
  spec.email = ["jay.schneider@zweitag.de"]

  spec.summary = "Infer data types from external sources to create a rails model for example"
  spec.description = "This gem tries to detect the data type from given data like a csv file. You can then use this information to generate a rails migration to have a fitting model for the data."
  spec.homepage = "https://github.com/Jay-Schneider/infer_model"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/Jay-Schneider/infer_model/issues",
    "changelog_uri" => "https://github.com/Jay-Schneider/infer_model/CHANGELOG.md",
    "homepage_uri" => spec.homepage,
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/Jay-Schneider/infer_model",
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 7.0"
  spec.add_dependency "dry-initializer", "~> 3.0"
  spec.add_development_dependency "dotenv", "~> 2.8"
  spec.add_development_dependency "pry", "~> 0.14"
  spec.add_development_dependency "rspec", "~> 3.11"
  spec.add_development_dependency "rubocop", "~> 1.36"
  spec.add_development_dependency "rubocop-performance", "~> 1.14"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
