# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "remote_cp/version"

Gem::Specification.new do |s|
  s.name        = "remote_cp"
  s.version     = RemoteCp::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Martin Chabot"]
  s.email       = ["chabotm@gmail.com"]
  s.homepage    = "http://github.com/martinos/remote_cp"
  s.summary     = %q{Tools to facilitate file transfert across machine}
  s.description = %q{Tools to facilitate file transfert across machine}

  s.rubyforge_project = "remote_cp"
  
  s.add_dependency "aws-s3"
  s.add_dependency "thor"
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
