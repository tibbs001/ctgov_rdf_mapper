require File.dirname(__FILE__) + '/spec_helper'

describe VivoMapper::Address do
  it "should initialize with a hash of attributes" do
    a = VivoMapper::Address.new(:uid => 123,
                                :label => "Test Label",
                                :street => "100 Main St.",
                                :city => "Durham",
                                :state => "NC",
                                :zip_code => "27701",
                                :country => "US",
                                :phone => "919-555-1212",
                                :person_uid => "01234567")

    a.uid.should eql(123)
    a.label.should eql("Test Label")
    a.street.should eql("100 Main St.")
    a.city.should eql("Durham")
    a.state.should eql("NC")
    a.zip_code.should eql("27701")
    a.country.should eql("US")
    a.phone.should eql("919-555-1212")
  end

end
