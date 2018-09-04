$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "rails5jrubyplugin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails5jrubyplugin"
  s.version     = Rails5jrubyplugin::VERSION
  s.authors     = ["tibbs001"]
  s.email       = ["sheri.tibbs@duke.edu"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Rails5jrubyplugin."
  s.description = "TODO: Description of Rails5jrubyplugin."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"

  s.add_development_dependency "activerecord-jdbcsqlite3-adapter"
end
