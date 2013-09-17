# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "shibboleth-rails/version"

Gem::Specification.new do |s|
  s.name        = "shibboleth-rails"
  s.version     = Shibboleth::Rails::VERSION
  s.authors     = ["mikegee"]
  s.email       = ["gee.24@osu.edu"]
  s.homepage    = "https://github.com/ASCTech/shibboleth-rails"
  s.summary     = %q{This Rails plugin integrates Shibboletth single signon.}
  s.description = %q{Environment variables that Shibboleth sets are used to determine 'current_user'.  An interface to login as any user is also provided for running in development.}

  s.rubyforge_project = "shibboleth-rails"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "rails", '> 3.0'
end
