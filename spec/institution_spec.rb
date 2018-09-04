require File.dirname(__FILE__) + '/spec_helper'

describe VivoMapper::Institution do
  it "should initialize with a hash of attributes" do
    a = VivoMapper::Institution.new(:uid => 123,
                                    :label => "Test Label",
                                    :type => "Type")

    a.uid.should eql(123)
    a.label.should eql("Test Label")
    # TODO: this should be fixed - type might be a special method is jruby 1.6.5
    #a.type.should eql("Type")
  end

end
