require File.dirname(__FILE__) + '/spec_helper'

class TestMappable < VivoMapper::Resource
  attr_reader :test_id, :test_data_attribute, :test_object_attribute

  def initialize(test_id, test_data_attribute, test_object_attribute)
    @test_id, @test_data_attribute, @test_object_attribute = test_id, test_data_attribute, test_object_attribute
    super()
  end
end

module TestMappableMap
  extend self

  def uri(namespace, mappable)
    "#{namespace}#{mappable.test_id}"
  end

  def types(mappable)
    []
  end

  def inferred_types
    []
  end

  def properties(mappable)
    {
      "http://testing/exampleDataAttribute" => mappable.test_data_attribute,
      "http://testing/exampleObjectAttribute" => mappable.test_object_attribute
    }
  end
end

TestMappable.map_with(TestMappableMap)

module TestJenaObjects
  extend self
  java_import 'com.hp.hpl.jena.rdf.model.ModelFactory'
  java_import 'com.hp.hpl.jena.util.FileManager'
  java_import 'com.hp.hpl.jena.ontology.OntModelSpec'

  def ontology_model
    ont_model = ModelFactory.create_ontology_model
    FileManager.get.readModel(ont_model,'config/ontologies/vivo-core-public-1.4.owl')
    FileManager.get.readModel(ont_model,'config/ontologies/vitro-0.7.owl')
    FileManager.get.readModel(ont_model,'config/ontologies/duke_extension.owl')

    ont_model.create_datatype_property("http://testing/exampleDataAttribute")
    ont_model.create_object_property("http://testing/exampleObjectAttribute")
    ont_model
  end

  def empty_model
    ModelFactory.create_default_model
  end

  def test_person_model
    model = ModelFactory.create_default_model
    test_person_rdf_path = File.join(SPEC_ROOT,"files","test_person.rdf")
    FileManager.get.readModel(model,test_person_rdf_path)
    model
  end

  def test_person_modified_model
    model = ModelFactory.create_default_model
    test_person_rdf_path = File.join(SPEC_ROOT,"files","test_person_modified.rdf")
    FileManager.get.readModel(model,test_person_rdf_path)
    model
  end

  def vivo_ontology_model
    ontology_model
  end
end
