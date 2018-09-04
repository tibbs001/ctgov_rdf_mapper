require File.dirname(__FILE__) + '/spec_helper'

describe VivoMapper::DateInterval do
  it "should initialize with a start_date, end_date and a precision" do
    di = VivoMapper::DateInterval.new(Date.parse("01/01/2010"),Date.parse("01/01/2011"),"year")
    di.start_date.should eql(Date.parse("01/01/2010"))
    di.end_date.should eql(Date.parse("01/01/2011"))
    di.precision.should eql("year")
  end

  it "should respond to start_date_value with a DateValue representation of start_date with a matching precision" do
    di = VivoMapper::DateInterval.new(Date.parse("01/01/2010"),Date.parse("01/01/2011"),"year")
    di.start_date_value.should be_instance_of VivoMapper::DateValue
    di.start_date_value.date.should eql(di.start_date)
    di.start_date_value.precision.should eql(di.precision)
  end

  it "should respond to end_date_value with a DateValue representation of end_date with a matching precision" do
    di = VivoMapper::DateInterval.new(Date.parse("01/01/2010"),Date.parse("01/01/2011"),"year")
    di.end_date_value.should be_instance_of VivoMapper::DateValue
    di.end_date_value.date.should eql(di.end_date)
    di.end_date_value.precision.should eql(di.precision)
  end
end
