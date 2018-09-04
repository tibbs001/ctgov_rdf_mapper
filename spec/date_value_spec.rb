require File.dirname(__FILE__) + '/spec_helper'

describe VivoMapper::DateValue do

  it "should initialize with date and precision" do
    dv = VivoMapper::DateValue.new(Date.parse("01/01/2011"),"yearMonthDay")
    dv.date.should eql(Date.parse("01/01/2011"))
    dv.precision.should eql("yearMonthDay")
  end
end
