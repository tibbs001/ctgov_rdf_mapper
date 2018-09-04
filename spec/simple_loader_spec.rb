require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/mapper_spec_helper'

describe VivoMapper::SimpleLoader do

  it "should initialize with staging and destination Jena models" do
    staging_model = TestJenaObjects.empty_model
    destination_model = TestJenaObjects.empty_model
    sl = VivoMapper::SimpleLoader.new(staging_model,destination_model)
    sl.staging_model.should equal(staging_model)
    sl.destination_model.should equal(destination_model)
  end

  describe "responding to add_model with a non-empty incoming model" do

    it "should add all statements in the incoming model to the staging and destination models" do
      staging_model = TestJenaObjects.empty_model
      destination_model = TestJenaObjects.empty_model
      incoming_model    = TestJenaObjects.test_person_model
      sl = VivoMapper::SimpleLoader.new(staging_model,destination_model)

      staging_model.contains_all(incoming_model).should be false
      destination_model.contains_all(incoming_model).should be false
      sl.add_model(incoming_model)
      staging_model.contains_all(incoming_model).should be true
      destination_model.contains_all(incoming_model).should be true
    end

  end

  describe "responding to remove_model with a non-empty incoming model" do

    it "should remove all statements in the incoming model from the staging and destination models" do
      staging_model = TestJenaObjects.test_person_model
      destination_model = TestJenaObjects.test_person_model
      incoming_model    = TestJenaObjects.test_person_model
      sl = VivoMapper::SimpleLoader.new(staging_model,destination_model)

      staging_model.contains_all(incoming_model).should be true
      destination_model.contains_all(incoming_model).should be true
      sl.remove_model(incoming_model)
      staging_model.contains_any(incoming_model).should be false
      destination_model.contains_any(incoming_model).should be false
    end

  end
end
