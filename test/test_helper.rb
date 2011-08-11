$:.push File.expand_path('../../', __FILE__)

require 'logger'
require 'test/unit'
require 'active_record'
require 'active_support'
require 'active_support/test_case'

require 'lib/record_with_operator'

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(config['sqlite3'])

load(File.dirname(__FILE__) + "/schema.rb")
