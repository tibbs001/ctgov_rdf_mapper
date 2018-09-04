require File.dirname(__FILE__) + '/spec_helper'


describe VivoMapper::User do

  before(:all)  do
    @model_name      = 'User'
    a = VivoMapper::User.new(
       :uid               => 'http://scholars.duke.edu/individual/u123',
       :external_auth_id  => 'test',
       :first_name        => 'user',
       :last_name         => 'user',
       :email_address     => 'user.user@duke.edu',
       :password          => '12345')  
    @im = TestHelper.get_import_manager
    @users = [a]
  end

  xit "should initialize with a hash of attributes" do
    @users.first.uid.should eql('http://scholars.duke.edu/individual/u123')
    @users.first.external_auth_id.should eql("test")
    @users.first.first_name.should eql("user")
    @users.first.last_name.should eql("user")
    @users.first.email_address.should eql("user.user@duke.edu")
  end

  xit "should populate the incoming sdb with user resources" do
    @im.truncate('incoming')
    @im.size(@model_name,'incoming').should equal(0)
    @im.simple_import(@model_name, @users)
    @im.size(@model_name,'incoming').should  > 0
    @im.size(@model_name,'staging').should  > 0
    @im.size(@model_name,'staging').should == @im.size(@model_name, 'incoming')
  end

end
