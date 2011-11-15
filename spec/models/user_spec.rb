require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "Scenario 1" do

  def self.before_suite
    #any variables that may need instantiated once per whole suite
    #@@company = Company.make

    #basically admitting...	
    #i_suck_and_my_tests_are_order_dependent!  
    #needs if you need to remove random case testing which is the default
  end

  it "Case 1" do	
    #.... 
  end

  def self.after_suite
    #teardown after the whole suite
  end
end
