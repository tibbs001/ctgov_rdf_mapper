# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "vivo_mapper/version"

Gem::Specification.new do |s|
  s.name        = "vivo_mapper"
  s.version     = VivoMapper::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["TODO: Write your name"]
  s.email       = ["TODO: Write your email address"]
  s.homepage    = ""
  s.summary     = %q{Ruby wrapper project for loading RDF into VIVO}
  s.description = %q{Ruby wrapper project for loading RDF into VIVO}

  s.rubyforge_project = "vivo_mapper"

  s.files             = %w( README.md Rakefile LICENSE )
  s.files            += Dir.glob("lib/**/*")
  s.files            += Dir.glob("bin/**/*")
  s.files            += Dir.glob("config/**/*")
  s.files            += Dir.glob("test/**/*")
  s.files            += Dir.glob("script/**/*")
  s.files            += Dir.glob("examples/**/*")
  s.files            += Dir.glob("app/**/*")
    
  s.require_paths = ["lib"]
end
