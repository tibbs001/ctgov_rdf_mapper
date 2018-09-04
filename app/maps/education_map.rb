java_import 'com.hp.hpl.jena.rdf.model.ModelFactory'
java_import 'com.hp.hpl.jena.query.QueryFactory'
java_import 'com.hp.hpl.jena.query.QueryExecutionFactory'

module EducationMap
  include RdfPrefixes

  extend self

  def uri(namespace,e)
    "#{namespace}edu#{e.uid}"
  end

  def types(e)
    [core("EducationalTraining")]
  end

  def inferred_types(e)
    [owl("Thing")]
  end

  def properties(e)
    {
      rdfs("label") => e.label,
      core("educationalTrainingOf")  => VivoMapper::Person.new(:uid => e.person_uid).stub,
      core("trainingAtOrganization") => VivoMapper::Institution.new(:uid => e.institution_uid).stub,
      core("degreeEarned")           => VivoMapper::Degree.new(:uid => e.degree_uid).stub,
      core("dateTimeInterval")       => e.date_interval
    }
  end

  def self.staging_uris(person_uri)
    "PREFIX vivo: <http://vivoweb.org/ontology/core#>
     SELECT  ?education 
     WHERE {
       <#{person_uri}> vivo:educationalTraining ?education
     }"
  end

  def self.sparql_constructs(person_uri, map_type='Regular')
    if map_type == 'Regular'
      sparql =<<-EOS
        PREFIX vivo: <http://vivoweb.org/ontology/core#>
        CONSTRUCT {
          <#{person_uri}> vivo:educationalTraining ?education .
          ?education vivo:educationalTrainingOf <#{person_uri}>
        }
        WHERE {
          <https://scholars.duke.edu/individual/per0293331> vivo:educationalTraining ?education
        }
      EOS
    else
      sparql =<<-EOS
        PREFIX vivo: <http://vivoweb.org/ontology/core#>
        PREFIX vitro: <http://vitro.mannlib.cornell.edu/ns/vitro/0.7#>
        PREFIX rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
        PREFIX owl:   <http://www.w3.org/2002/07/owl#>
        CONSTRUCT {
          ?education vitro:mostSpecificType  vivo:Education .
          ?education rdf:type                vivo:Education .
          ?education rdf:type                owl:Thing .
          ?education rdf:type                vivo:Agreement .
        }
        WHERE {
          <#{person_uri}> vivo:educationalTraining ?education
        }
      EOS
    end
    Array(sparql)
  end

  def self.graph_for(person_uri, model, map_type='Regular')
    graph_model = ModelFactory.create_default_model

    sparql_constructs = sparql_constructs(person_uri, map_type)
    sparql_constructs.each do |sparql_construct|
      query = QueryFactory.create(sparql_construct);
      qexec = QueryExecutionFactory.create(query, model);
      results = qexec.execConstruct();
      graph_model.add(results)
      qexec.close() ;
    end
    puts "*************************"
    puts graph_model
    puts "*************************"
    graph_model
  end


end
