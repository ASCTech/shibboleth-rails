$:.push File.expand_path("../lib", __FILE__)

require "shibboleth/rails/version"

Gem::Specification.new do |s|
  s.name        = "shibboleth-rails"
  s.version     = Shibboleth::Rails::VERSION
  s.authors     = ["Kyle Decot"]
  s.email       = ["decot.7@osu.edu"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of ShibbolethRails."
  s.description = "TODO: Description of ShibbolethRails."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "> 4.0.0"

end
