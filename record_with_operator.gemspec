# -*- mode: ruby; coding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "record_with_operator/version"

Gem::Specification.new do |s|
  s.name        = "record_with_operator"
  s.version     = RecordWithOperator::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Yasuko Ohba"]
  s.email       = ["y.ohba@everyleaf.com"]
  s.homepage    = "https://github.com/nay/record_with_operator"
  s.summary     = %q{Rails plugin to set created_by, updated_by, deleted_by to ActiveRecord objects. Supports associations.}
  s.description = %q{RecordWithOperator is a rails plugin that makes your all active record models to be saved or logically deleted with created_by, updated_by, deleted_by automatically. Also it makes creator, updater, deleter association (belongs_to) if the class has created_by, updated_by, deleted_by.}

  s.rubyforge_project = "record_with_operator"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extra_rdoc_files = ['README.rdoc']
  s.require_paths = ["lib"]

  s.licenses = ["MIT"]

  s.add_dependency 'activerecord'
  s.add_development_dependency 'bundler', ['>= 1.0.0']
  s.add_development_dependency 'rake', ['>= 0.8.7']
  s.add_development_dependency 'sqlite3', ['>= 0']
end
