ENV["RAILS_ENV"] = 'test'

require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))

require 'minitest/autorun'
require 'minitest/pride'
require 'turn'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

require File.join(File.dirname(__FILE__), 'blueprints')

Rails.backtrace_cleaner.remove_silencers!

MiniTest::Unit.runner = MiniTestSuite::Unit.new

#before running the test suite
MiniTest::Unit.runner.before_all do 
  #any code that should run before all the specs
  #Sham.reset(:before_all)
end

#before each test
MiniTest::Unit::TestCase.add_setup_hook { 
 #Sham.reset(:before_each) 
}
