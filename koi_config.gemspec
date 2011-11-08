# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "koi_config/version"

Gem::Specification.new do |s|
  s.name        = "koi_config"
  s.version     = KoiConfig::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Rahul Trikha"]
  s.email       = ["rahul@katalyst.com.au"]
  s.homepage    = "http://www.katalyst.com.au/"
  s.summary     = %q{DSL to write KoiCMS CRUD configuration}
  s.description = %q{DSL provides ability to define default or new configurations.
                     Existing configurations are merged rather than being over written.}

  s.rubyforge_project = "koi_config"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

