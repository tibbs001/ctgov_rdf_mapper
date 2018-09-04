require File.dirname(__FILE__) + '/spec_helper'

describe VivoMapper::Appointment do
  it "should initialize with a person instance, and organization instance, and a hash of attributes" do
    a = VivoMapper::Appointment.new(:person_uid => 345,
                                    :organization_uid => 567,
                                    :uid => 123,
                                    :label => "Test Label",
                                    :title => "Professor",
                                    :display_order => 3,
                                    :start_year => 2009,
                                    :start_date => Date.parse("02/01/2009"),
                                    :end_year => 2010,
                                    :end_date => Date.parse("04/01/2010"),
                                    :position_type => "Academic Appointment")

    a.uid.should eql(123)
    a.label.should eql("Test Label")
  end


  it "should respond to date_interval with a yearMonthDay precision DateInterval based on start_date if start_date is available" do
    a = VivoMapper::Appointment.new(:start_date => Date.parse("01/01/2010"), :start_year => 2010)
    a.date_interval.should be_instance_of(VivoMapper::DateInterval)
    a.date_interval.start_date.should eql(a.start_date)
    a.date_interval.end_date.should eql(a.end_date)
    a.date_interval.precision.should  eql("yearMonthDay")
  end

  it "should respond to date_interval with a year precision DateInterval based on start_year if start_year is available and start_date is empty" do
    a = VivoMapper::Appointment.new(:start_year => 2010)
    a.date_interval.should be_instance_of(VivoMapper::DateInterval)
    a.date_interval.start_date.should eql(DateTime.parse("01/01/#{a.start_year}"))
    a.date_interval.end_date.should eql(a.end_year)
    a.date_interval.precision.should  eql("year")
  end

  it "should respond to date_interval with nil if start_date and start_year are empty" do
    a = VivoMapper::Appointment.new
    a.date_interval.should eql(nil)
  end
  
end
