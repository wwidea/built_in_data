require_relative "lib/built_in_data/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "built_in_data"
  spec.version     = BuiltInData::VERSION
  spec.authors     = ["Aaron Baldwin", "Brightways Learning"]
  spec.email       = ["baldwina@brightwayslearning.org"]
  spec.homepage    = "https://github.com/wwidea/built_in_data"
  spec.summary     = "Data management for Rails models."
  spec.description = "BuiltInData is a simple tool for loading and updating data in a Rails application."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.required_ruby_version = ">= 2.7.0"
  spec.add_runtime_dependency "activerecord", ">= 5.0.0"
end
