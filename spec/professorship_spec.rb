require File.dirname(__FILE__) + '/spec_helper'

describe VivoMapper::Professorship do
  it "should initialize with a hash of attributes" do
    a = VivoMapper::Professorship.new(:uid => 123,
                                    :label => "Test Label",
                                    :title => "Professor",
                                    :display_order => 3,
                                    :start_date => Date.parse("02/01/2009"),
                                    :end_date => Date.parse("04/01/2010"),
                                    :position_type => "Academic Professorship",
                                    :person_uri => "http://test.edu/person/123",
                                    :organization_uri => "http://test.duke/org/321")

    a.uid.should eql(123)
    a.label.should eql("Test Label")
  end


  it "should respond to date_interval with a yearMonthDay precision DateInterval based on start_date if start_date is available" do
    a = VivoMapper::Professorship.new(:start_date => Date.parse("01/01/2010"))
    a.date_interval.should be_instance_of(VivoMapper::DateInterval)
    a.date_interval.start_date.should eql(a.start_date)
    a.date_interval.end_date.should eql(a.end_date)
    a.date_interval.precision.should  eql("yearMonthDay")
  end

  it "should respond to date_interval with nil if start_date is empty" do
    a = VivoMapper::Professorship.new
    a.date_interval.should eql(nil)
  end
  
end
