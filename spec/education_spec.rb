require File.dirname(__FILE__) + '/spec_helper'

describe VivoMapper::Education do
  xit "should initialize with a hash of attributes" do
    a = VivoMapper::Education.new(:uid => 123,
                                    :label => "Test Label",
                                    :major_field_of_study => "Biology",
                                    :person => 3,
                                    :start_year => 2009,
                                    :start_date => Date.parse("02/01/2009"),
                                    :end_year => 2010,
                                    :end_date => Date.parse("04/01/2010"),
                                    :institution => 1)

    a.uid.should eql(123)
    a.label.should eql("Test Label")
    a.major_field_of_study.should eql("Biology")
  end


  xit "should respond to date_interval with a yearMonthDay precision DateInterval based on start_date if start_date is available" do
    a = VivoMapper::Education.new(:start_date => Date.parse("01/01/2010"), :start_year => 2010)
    #a.date_interval.should be_instance_of(VivoMapper::DateInterval)
    a.date_interval.start_date.should eql(a.start_date)
    a.date_interval.end_date.should eql(nil)
    a.date_interval.precision.should  eql("yearMonthDay")
  end

  xit "should respond to date_interval with a year precision DateInterval based on start_year if start_year is available and start_date is empty" do
    a = VivoMapper::Education.new(:start_year => 2010)
    a.date_interval.should be_instance_of(VivoMapper::DateInterval)
    a.date_interval.start_date.should eql(a.start_year)
    a.date_interval.end_date.should eql(a.end_year)
    a.date_interval.precision.should  eql("year")
  end

  xit "should respond to date_interval with nil if start_date and start_year are empty" do
    a = VivoMapper::Education.new
    a.date_interval.should eql(nil)
  end
  
end
