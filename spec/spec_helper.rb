$:.unshift(File.dirname(__FILE__) + '/../lib')

ENV["RAILS_ENV"] ||= "test"

require "rubygems"
require 'spec'
require File.expand_path(File.join(File.dirname(__FILE__), "../../../../config/environment"))
require 'spec/rails'
require 'active_record/fixtures'

begin
  require 'ruby-debug'
  Debugger.start
rescue LoadError
end

require "acts_as_eav_model"

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'mysql'])

plugin_fixture_path = File.expand_path(File.dirname(__FILE__) + "/fixtures/")
$LOAD_PATH.unshift(plugin_fixture_path)

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = plugin_fixture_path
end

load(File.dirname(__FILE__) + "/schema.rb")

alias :doing :lambda