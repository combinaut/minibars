$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "minibars/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "minibars"
  s.version     = Minibars::VERSION
  s.authors     = ["Nicholas Jakobsen", "Delon Newman"]
  s.email       = ["nicholas@combinaut.com", "contact@delonnewman.name"]
  s.homepage    = "https://github.com/combinaut/minibars"
  s.summary     = "Minibars is a stripped down implementation of Handlerbars using MiniRacer."
  s.description = "Minibars is a stripped down implementation of Handlerbars using MiniRacer. It eschews capabilities that require two-way binding with the JS runtime, making it a good choice for those with simple Handlebars templates who need an upgrade path for their ARM64 architecture."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency 'mini_racer', '~> 0.4.0'
  s.add_dependency 'handlebars-source'

  s.add_development_dependency 'rspec', '~> 3.7'
end
