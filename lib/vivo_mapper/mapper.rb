java_import 'com.hp.hpl.jena.ontology.OntModelSpec'
java_import 'com.hp.hpl.jena.rdf.model.ModelFactory'
java_import 'com.hp.hpl.jena.datatypes.xsd.XSDDatatype'

module VivoMapper
  class Mapper
    include RdfPrefixes

    attr_reader :namespace, :model, :ontology_model, :map_type

    def initialize(namespace, model, ontology_model, map_type = 'Regular')
      @namespace, @model, @ontology_model, @map_type = namespace, model, ontology_model, map_type
      #  hack to see if I can just get it to work
      Dir.glob("#{MAPPER_ROOT}/config/ontologies/*.owl") do |ontology_file|
        SDB_CONFIG.read_ontology_file(ontology_file)
      end
      @ontology_model=SDB_CONFIG.ontology_model
    end

    def map_resource(mappable, mapping = nil)
      mapping ||= mappable.mapping
      resource = @model.create_resource(assign_uri(mappable, mapping))
      assign_types(resource, mappable, mapping) unless mappable.stubbed
      assign_properties(resource, mappable, mapping) if (!mappable.stubbed && @map_type == 'Regular')
      resource
    end

    def assign_uri(mappable, mapping)
      mapping.uri(@namespace,mappable)
    end

    def assign_types(resource, mappable, mapping)
      if @map_type == 'Inferred'
        most_specific_type = mapping.most_specific_type(mappable)
        type_property = @ontology_model.get_ont_property(vitro("mostSpecificType"))
        type_resource = @model.create_resource(most_specific_type)
        resource.add_property(type_property,type_resource)

        types = mapping.inferred_types(mappable)
        type_property = @ontology_model.get_ont_property(rdf("type"))
        types.each do |type|
          type_resource = @model.create_resource(type)
          resource.add_property(type_property,type_resource)
        end
        mapping.child_maps(mappable).each {|child| map_resource(child)}
      else
        types = mapping.types(mappable)
        type_property = @ontology_model.get_ont_property(rdf("type"))
        types.each do |type|
          type_resource = @model.create_resource(type)
          resource.add_property(type_property,type_resource)
        end
      end
    end

    def assign_properties(resource, mappable, mapping)
      puts  "======== Ont Properties =============================================="
      puts @ontology_model.listAllOntProperties.each{|x| puts x}
      puts  "======================================================"
      mapping.properties(mappable).each do |predicate_uri,object_value|
        puts ">>>>>>>>>>>>>>>>>>>>> mapping  #{predicate_uri}   #{object_value}"
        unless object_value.nil?
          predicate = @ontology_model.get_ont_property(predicate_uri)
          raise "#{predicate_uri} not found in ontology" unless predicate # TODO: make real error class to raise

            if predicate.is_object_property
              if object_value.respond_to? :mapping
                # recursively map sub object, add object property linking to resource
                linked_resource = map_resource(object_value)
                resource.add_property(predicate, linked_resource)
              else
                 # assume object value is resource uri
                 linked_resource = @model.create_resource(object_value)
                 resource.add_property(predicate,linked_resource)
              end

              inverse_properties_iter = predicate.list_inverse
              while inverse_properties_iter.has_next
                inverse_predicate = inverse_properties_iter.next
                linked_resource.add_property(inverse_predicate,resource)
              end
            else
              case object_value
              when DateTime
                # force typing of dates
                resource.add_property(predicate,@model.create_typed_literal(object_value.to_s[0..18],XSDDatatype::XSDdateTime))
              when Integer
                resource.add_property(predicate,@model.create_typed_literal(object_value.to_s[0..18],XSDDatatype::XSDdecimal))
              when *[true, false]
                resource.add_property(predicate,@model.create_typed_literal(object_value.to_s[0..18],XSDDatatype::XSDboolean))
              else
                resource.add_property(predicate,object_value)
              end
            end
        end
      end
    end
  end
end

