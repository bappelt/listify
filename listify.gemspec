$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "listify/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "listify"
  s.version     = Listify::VERSION
  s.authors     = ["Byron Appelt "]
  s.email       = ["byron.appelt@gmail.com"]
  s.homepage    = "http://bappelt.github.io/listify"
  s.summary     = "HTML list generator plugin for Rails"
  s.description = "Rails plugin that generates HTML lists from ruby array and hash objects"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.14"
end
