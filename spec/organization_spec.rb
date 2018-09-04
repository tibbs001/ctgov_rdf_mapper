require File.dirname(__FILE__) + '/spec_helper'

describe VivoMapper::Organization do
  it "should initialize with a hash of attributes" do
    a = VivoMapper::Organization.new(:label => "Test Label",
                                    :type => "Type",
                                    :uid => "50012021",
                                    :parent_uri => 1)

    a.label.should eql("Test Label")
    a.type.should eql("Type")
    a.uid.should eql("50012021")
  end

end
