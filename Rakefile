require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'

NAME = "record_with_operator"
AUTHOR = "Yasuko Ohba"
EMAIL = "y.ohba@everyleaf.com"
DESCRIPTION = "Rails plugin to set created_by, updated_by, deleted_by to ActiveRecord objects. Supports associations."
GITHUB_PROJECT = "record_with_operator"
HOMEPAGE = "http://github.com/nay/#{GITHUB_PROJECT}/tree"
BIN_FILES = %w( )
VER = "0.0.8"
CLEAN.include ['pkg']

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the record_with_operator plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the record_with_operator plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'RecordWithOperator'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

spec = Gem::Specification.new do |s|
  s.name = NAME
  s.version = VER
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc", "MIT-LICENSE"]
  s.rdoc_options += ['--line-numbers', '--inline-source']
  s.summary = DESCRIPTION
  s.description = DESCRIPTION
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.executables = BIN_FILES
  s.bindir = "bin"
  s.require_path = "lib"
  s.test_files = Dir["test/*.{rb,yml}"]

  s.add_dependency('activerecord', '>=2.2.0')
  
  s.files = %w(README.rdoc Rakefile MIT-LICENSE) +
    %w(install.rb uninstall.rb init.rb) +
    Dir.glob("{bin,doc,lib,tasks,rails}/**/*")

end

Rake::GemPackageTask.new(spec) do |p|
  p.need_tar = true
  p.gem_spec = spec
end

desc 'Update gem spec'
task :gemspec do
  open("#{NAME}.gemspec", "w").write spec.to_ruby
end
