require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/mapper_spec_helper'

describe VivoMapper::Config do
 
  # TODO: make a factory to avoid specific assertions about what's in the yaml files
  xit "should generate a config object for the Import Manager for development" do
    config=VivoMapper::Config.load_from_file('spec/files/test_configs.yml')
    (config.incoming_sdb.kind_of? VivoMapper::SDB).should == true
    (config.staging_sdb.kind_of? VivoMapper::SDB).should == true
    (config.destination_sdb.kind_of? VivoMapper::SDB).should == true
    config.namespace.should == 'http://example.edu'
    config.destination_model_name.should == 'http://vitro.mannlib.cornell.edu/default/vitro-kb-2'
    config.inference_model_name.should == 'http://vitro.mannlib.cornell.edu/default/vitro-kb-inf'
    config.incoming_sdb.instance_variable_get('@username').should == 'sa'
    config.incoming_sdb.instance_variable_get('@driver_class_name').should == 'org.h2.Driver'
    config.incoming_sdb.instance_variable_get('@db_type').should == 'H2'
    config.incoming_sdb.instance_variable_get('@layout_type').should == 'layout2/hash'
  end
  
  it "should generate a config object for the Import Manager for test" do
    config=VivoMapper::Config.load_from_file('spec/files/test_configs.yml','test')
    (config.incoming_sdb.kind_of? VivoMapper::SDB).should == true
    (config.staging_sdb.kind_of? VivoMapper::SDB).should == true
    (config.destination_sdb.kind_of? VivoMapper::SDB).should == true
    config.namespace.should == 'http://test-example.edu'
    config.destination_model_name.should == 'http://test'
    config.incoming_sdb.instance_variable_get('@username').should == 'test-sa'
    config.incoming_sdb.instance_variable_get('@password').should == 'test-password'
    config.incoming_sdb.instance_variable_get('@driver_class_name').should == 'org.h2.Driver'
  end
  
  it "should generate a config object for the Import Manager for production" do
    config=VivoMapper::Config.load_from_file('spec/files/test_configs.yml','production')
    (config.incoming_sdb.kind_of? VivoMapper::SDB).should == true
    (config.staging_sdb.kind_of? VivoMapper::SDB).should == true
    (config.destination_sdb.kind_of? VivoMapper::SDB).should == true
    config.namespace.should == 'http://prod-example.edu'
    config.destination_model_name.should == 'http://prod'
    config.incoming_sdb.instance_variable_get('@username').should == 'prod-sa'
    config.incoming_sdb.instance_variable_get('@password').should == 'prod-password'
    config.incoming_sdb.instance_variable_get('@driver_class_name').should == 'org.h2.Driver'
    config.staging_sdb.instance_variable_get('@username').should == 'prod-staging'
    config.destination_sdb.instance_variable_get('@username').should == 'prod-dest'
    config.destination_sdb.instance_variable_get('@password').should == 'prod-vivo'
  end
  
end
