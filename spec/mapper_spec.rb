require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/mapper_spec_helper'

describe VivoMapper::Mapper do

  describe "Responding to map_resource with a valid mappable object" do
    it "should answer with a resource in the passed model with a uri in the passed namespace" do
      java_import 'com.hp.hpl.jena.rdf.model.Resource'

      model = TestJenaObjects.empty_model

      mapper = VivoMapper::Mapper.new("http://testing/",model,TestJenaObjects.ontology_model)
      mappable = TestMappable.new(123,"Test Data",nil)
      resource = mapper.map_resource(mappable)
      resource.get_uri.should eql("http://testing/123")
      resource.should be_kind_of Resource
      model.get_resource("http://testing/123").should eql(resource)

    end

    it "should map all data properties in the associate map" do
      ontology_model = TestJenaObjects.ontology_model

      mapper = VivoMapper::Mapper.new("http://testing/",TestJenaObjects.empty_model,ontology_model)
      mappable = TestMappable.new(123,"Test Data",nil)
      resource = mapper.map_resource(mappable)

      example_data_property = ontology_model.get_ont_property("http://testing/exampleDataProperty")

      resource.get_property(example_data_property).get_object.to_s.should eql("Test Data")
    end

    it "should map all unmappale object properties in the map as linked stubbed resources" do
      model = TestJenaObjects.empty_model
      ontology_model = TestJenaObjects.ontology_model

      mapper = VivoMapper::Mapper.new("http://testing/",model,ontology_model)
      mappable = TestMappable.new(123,nil,"http://testing/another_resource")
      resource = mapper.map_resource(mappable)

      example_object_property = ontology_model.get_ont_property("http://testing/exampleObjectProperty")

      resource.get_property(example_object_property).get_object.should eql(model.get_resource("http://testing/another_resource"))

    end

    it "should link and map mappable object poperties fully" do
      model = TestJenaObjects.empty_model
      ontology_model = TestJenaObjects.ontology_model

      mapper = VivoMapper::Mapper.new("http://testing/",model,ontology_model)
      submappable = TestMappable.new(456,"Test Data",nil)
      mappable = TestMappable.new(123,nil,submappable)
      resource = mapper.map_resource(mappable)

      example_object_property = ontology_model.get_ont_property("http://testing/exampleObjectProperty")
      resource.get_property(example_object_property).get_object.should eql(mapper.map_resource(submappable))

    end

  end

end
