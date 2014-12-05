$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "visma/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "visma"
  s.version     = Visma::VERSION
  s.authors     = ["Voit AS"]
	s.email       = ["business@voit.no"]
	s.homepage    = "http://voit.no"
  s.summary     = "Integrations with Visma Global"
	s.description = "Integrations with Visma Global ERP software"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.5"

	#Databases
	s.add_dependency "tiny_tds", ">= 0.6.2"
	s.add_dependency "activerecord-sqlserver-adapter", ">= 3.2.12"

end
