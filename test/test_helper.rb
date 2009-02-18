require 'rubygems'
require File.expand_path(File.join(File.dirname(__FILE__), '../../../../config/environment.rb'))
require 'test/unit'
require 'active_support'
require 'active_support/test_case'
require 'common_models'

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(config['mysql'])

load(File.dirname(__FILE__) + "/schema.rb")
