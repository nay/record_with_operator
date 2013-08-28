require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
#require 'rdoc/task'
#require 'rake/gempackagetask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the record_with_operator plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

#desc 'Generate documentation for the record_with_operator plugin.'
#Rake::RDocTask.new(:rdoc) do |rdoc|
#  rdoc.rdoc_dir = 'rdoc'
#  rdoc.title    = 'RecordWithOperator'
#  rdoc.options << '--line-numbers' << '--inline-source'
#  rdoc.rdoc_files.include('README.rdoc')
#  rdoc.rdoc_files.include('lib/**/*.rb')
#end
