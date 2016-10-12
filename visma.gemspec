$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "visma/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "visma"
  s.version     = Visma::VERSION
  s.authors     = ["Marvin Wiik","Runar Ingebrigtsen"]
  s.email       = ["marvin@voit.no","runar@voit.no"]
  s.homepage    = "http://voit.no"
  s.summary     = "Integrate Rails 5 with Visma Global"
  s.description = "Visma Global ERP integration for Ruby on Rails. Requires support for SQL Server 2012 and newer."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  # This is a Rails engine
  s.add_dependency "rails", "~> 5.0"

  # Connect to Microsoft SQL Server 2012
#  s.add_dependency "tiny_tds", "~> 1.0"
#  s.add_dependency "activerecord-sqlserver-adapter", "~> 4.2"
end
