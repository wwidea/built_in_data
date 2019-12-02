$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "built_in_data/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "built_in_data"
  s.version     = BuiltInData::VERSION
  s.authors     = ['Aaron Baldwin', 'Brightways Learning']
  s.email       = ["developers@brightwayslearning.org"]
  s.homepage    = "https://github.com/wwidea/built_in_data"
  s.summary     = "Data management for Rails models."
  s.description = "BuiltInData is a simple tool for loading and updating data in a Rails application."
  s.license     = 'MIT'

  s.files       = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files  = Dir["test/**/*"]

  s.add_runtime_dependency "rails", ">=4.0.0"

  s.add_development_dependency "sqlite3", "~> 1.4"
end
