require File.dirname(__FILE__) + '/spec_helper'
 
describe VivoMapper::Person do
  it "should initialize with a hash of attributes" do
    a = VivoMapper::Person.new(:uid => 123,
                                    :label => "Test Label",
                                    :type => "Type",
                                    :username => "testp",
                                    :full_name => "Joe R. Smith",
                                    :first_name => "Joe",
                                    :last_name => "Smith",
                                    :mid_name => "R",
                                    :name_prefix => "Dr.",
                                    :name_suffix => "III",
                                    :title => "Professor") 
    a.uid.should eql(123)
    a.label.should eql("Test Label")
    a.type.should eql("Type")
    a.username.should eql("testp")
    a.full_name.should eql("Joe R. Smith")
    a.first_name.should eql("Joe")
    a.last_name.should eql("Smith")
    a.mid_name.should eql("R")
    a.name_prefix.should eql("Dr.")
    a.name_suffix.should eql("III")
    a.title.should eql("Professor")
  end

end
