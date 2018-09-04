java_import 'com.hp.hpl.jena.rdf.model.ModelFactory'
java_import 'com.hp.hpl.jena.query.QueryFactory'
java_import 'com.hp.hpl.jena.query.QueryExecutionFactory'

module GrantMap
  include RdfPrefixes
  extend self

  def self.sparql_constructs(person_uri, grant_uri, map_type='Regular')
    if map_type == 'Regular'
      [sparql_construct1(person_uri, grant_uri), sparql_construct2(person_uri, grant_uri), sparql_construct3(person_uri, grant_uri), sparql_construct4(person_uri, grant_uri)]
    else
      [inference_sparql_construct1(person_uri, grant_uri), inference_sparql_construct2(person_uri, grant_uri), inference_sparql_construct3(person_uri, grant_uri), inference_sparql_construct4(person_uri, grant_uri)]
    end
  end
 
  def self.staging_uris(person_uri)
    "PREFIX vivo: <http://vivoweb.org/ontology/core#>
     SELECT  ?grant 
     WHERE {  
           OPTIONAL { <#{person_uri}> vivo:hasPrincipalInvestigatorRole ?role }
           OPTIONAL {  <#{person_uri}> vivo:hasCo-PrincipalInvestigatorRole ?role }
           ?role           vivo:roleContributesTo   ?grant .
     }"
  end

  def self.sparql_construct1(person_uri, grant_uri)
    # the whole grant and all links to it if this person has the only role on the grant.
    "PREFIX vivo: <http://vivoweb.org/ontology/core#>
     CONSTRUCT {
          <#{person_uri}> vivo:hasPrincipalInvestigatorRole ?role . 
          ?role           vivo:roleContributesTo   ?grant .
          ?role           ?role_p                  ?role_o .
          ?grant          ?grant_p                 ?grant_o .
          ?sponsor        vivo:awardsGrant         ?grant .
          ?org            vivo:administers         ?grant .
          ?owned          vivo:subGrantOf          <#{grant_uri}> .
          ?owner          vivo:hasSubGrant         <#{grant_uri}> .
          <#{grant_uri}>  vivo:subGrantOf          ?parent .
          <#{grant_uri}>  vivo:hasSubGrant         ?child .
        }
     WHERE  
       { ?sponsor  vivo:awardsGrant         ?grant .
         ?org      vivo:administers         ?grant .
         ?role     vivo:roleContributesTo   ?grant .
        <#{person_uri}> vivo:hasPrincipalInvestigatorRole ?role .
         ?role     ?role_p                  ?role_o .
         ?grant    ?grant_p                 ?grant_o .   
         ?role     vivo:roleContributesTo   <#{grant_uri}> .
         OPTIONAL { ?owned          vivo:subGrantOf      <#{grant_uri}> }
         OPTIONAL { ?owner          vivo:hasSubGrant     <#{grant_uri}> }
         OPTIONAL { <#{grant_uri}>  vivo:subGrantOf      ?parent }
         OPTIONAL { <#{grant_uri}>  vivo:hasSubGrant     ?child }
       { SELECT distinct ?grant (count(?roles) as ?count)
          WHERE { OPTIONAL { <#{person_uri}> vivo:hasPrincipalInvestigatorRole ?role }
                  OPTIONAL { <#{person_uri}> vivo:hasCo-PrincipalInvestigatorRole ?role }
                  ?role     vivo:roleContributesTo   ?grant .
                  ?role     vivo:roleContributesTo    <#{grant_uri}> .
                  ?grant    vivo:contributingRole    ?roles . 
                }  GROUP BY ?grant
     }   } HAVING (?count = 1) "
  end

  def self.sparql_construct2(person_uri, grant_uri)
    # remove only the person's link to the grant if grant attached to other faculty.
    "PREFIX vivo: <http://vivoweb.org/ontology/core#>
     CONSTRUCT { 
          <#{person_uri}> vivo:hasPrincipalInvestigatorRole ?role .
          ?role           ?role_p                  ?role_o  .
          ?grant          ?grant_p                 ?role  .
     }
     WHERE  
       { 
        <#{person_uri}> vivo:hasPrincipalInvestigatorRole ?role .
         ?role     vivo:roleContributesTo   ?grant .
         ?role     ?role_p                  ?role_o .
         ?grant    ?grant_p                 ?role .
         ?role     vivo:roleContributesTo   <#{grant_uri}> .
       { SELECT distinct ?grant (count(?roles) as ?count)
          WHERE { OPTIONAL { <#{person_uri}>    vivo:hasPrincipalInvestigatorRole     ?role }
                  OPTIONAL { <#{person_uri}>    vivo:hasCo-PrincipalInvestigatorRole  ?role }
                  ?role     vivo:roleContributesTo   ?grant .
                  ?role     vivo:roleContributesTo    <#{grant_uri}> .
                  ?grant    vivo:contributingRole    ?roles . 
                }  GROUP BY ?grant
     }   } HAVING (?count > 1)"
  end

  # All CoPI relationships are getting deleted.   And the sub-grant link .
  def self.sparql_construct3(person_uri, grant_uri)
    # the whole grant and all links to it if this person has the only role on the grant.
    "PREFIX vivo: <http://vivoweb.org/ontology/core#>
     CONSTRUCT {
          <#{person_uri}> vivo:hasCo-PrincipalInvestigatorRole ?role . 
          ?role           vivo:roleContributesTo   ?grant .
          ?role           ?role_p                  ?role_o .
          ?grant          ?grant_p                 ?grant_o .
          ?sponsor        vivo:awardsGrant         ?grant .
          ?org            vivo:administers         ?grant .
          ?owned          vivo:subGrantOf          <#{grant_uri}> .
          ?owner          vivo:hasSubGrant         <#{grant_uri}> .
          <#{grant_uri}>  vivo:subGrantOf          ?parent .
          <#{grant_uri}>  vivo:hasSubGrant         ?child .
        }
     WHERE  
       { ?sponsor  vivo:awardsGrant         ?grant .
         ?org      vivo:administers         ?grant .
         ?role     vivo:roleContributesTo   ?grant .
        <#{person_uri}> vivo:hasCo-PrincipalInvestigatorRole ?role .
         ?role     ?role_p                  ?role_o .
         ?grant    ?grant_p                 ?grant_o .
         ?role     vivo:roleContributesTo   <#{grant_uri}> .
         OPTIONAL { ?owned          vivo:subGrantOf      <#{grant_uri}> }
         OPTIONAL { ?owner          vivo:hasSubGrant     <#{grant_uri}> }
         OPTIONAL { <#{grant_uri}>  vivo:subGrantOf      ?parent }
         OPTIONAL { <#{grant_uri}>  vivo:hasSubGrant     ?child }
       { SELECT distinct ?grant (count(?roles) as ?count)
          WHERE { OPTIONAL { <#{person_uri}>    vivo:hasPrincipalInvestigatorRole     ?role }
                  OPTIONAL { <#{person_uri}>    vivo:hasCo-PrincipalInvestigatorRole  ?role }
                  ?role     vivo:roleContributesTo    <#{grant_uri}> .
                  ?role     vivo:roleContributesTo   ?grant .
                  ?grant    vivo:contributingRole    ?roles . 
                }  GROUP BY ?grant
     }   } HAVING (?count = 1) "
  end

  def self.sparql_construct4(person_uri, grant_uri)
    # remove only the person's link to the grant if grant attached to other faculty.
    "PREFIX vivo: <http://vivoweb.org/ontology/core#>
     CONSTRUCT { 
          <#{person_uri}> vivo:hasCo-PrincipalInvestigatorRole ?role .
          ?role           ?role_p          ?role_o  .
          ?grant          ?grant_p         ?role .
     }
     WHERE  
       { 
        <#{person_uri}> vivo:hasCo-PrincipalInvestigatorRole ?role .
         ?role     vivo:roleContributesTo   ?grant .
         ?role     ?role_p                  ?role_o .
         ?grant    ?grant_p                 ?role .
         ?role     vivo:roleContributesTo   <#{grant_uri}> .
       { SELECT distinct ?grant (count(?roles) as ?count)
          WHERE { OPTIONAL { <#{person_uri}>    vivo:hasPrincipalInvestigatorRole     ?role }
                  OPTIONAL { <#{person_uri}>    vivo:hasCo-PrincipalInvestigatorRole  ?role }
                  ?role     vivo:roleContributesTo   ?grant .
                  ?grant    vivo:contributingRole    ?roles . 
                  ?role     vivo:roleContributesTo    <#{grant_uri}> .
                }  GROUP BY ?grant
     }   } HAVING (?count > 1)"
  end

  def self.inference_sparql_construct1(person_uri, grant_uri)
    "PREFIX vivo: <http://vivoweb.org/ontology/core#>
     PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#>
     PREFIX vitro: <http://vitro.mannlib.cornell.edu/ns/vitro/0.7#>
     PREFIX owl:   <http://www.w3.org/2002/07/owl#>
     CONSTRUCT { 
          <#{grant_uri}> vitro:mostSpecificType  vivo:Grant .
          <#{grant_uri}> rdfs:type              vivo:Grant .
          <#{grant_uri}> rdfs:type              owl:Thing .
          <#{grant_uri}> rdfs:type              vivo:Agreement .
          ?role          rdfs:type              owl:Thing .
          ?role          rdfs:type              vivo:Role .
          ?role          rdfs:type              vivo:ResearcherRole .
          ?role          rdfs:type              vivo:PrincipalInvestigatorRole .
          ?role          vitro:mostSpecificType  vivo:PrincipalInvestigatorRole .
     }
     WHERE {  
          <#{grant_uri}>  vivo:relatedRole        ?role .
           ?role          vivo:principalInvestigatorRoleOf  <#{person_uri}>
          { SELECT distinct ?grant (count(?roles) as ?count)
          WHERE { OPTIONAL { <#{person_uri}>    vivo:hasPrincipalInvestigatorRole     ?role }
                  OPTIONAL { <#{person_uri}>    vivo:hasCo-PrincipalInvestigatorRole  ?role }
                  ?role     vivo:roleContributesTo   ?grant .
                  ?grant    vivo:contributingRole    ?roles . 
                  ?role     vivo:roleContributesTo    <#{grant_uri}> .
                }  GROUP BY ?grant
     }   } HAVING (?count = 1)"
  end 
 
  def self.inference_sparql_construct2(person_uri, grant_uri)
    # PI on grant with other faculty associated.  (when hiding, don't get rid of grant)
    "PREFIX vivo: <http://vivoweb.org/ontology/core#>
     PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#>
     PREFIX vitro: <http://vitro.mannlib.cornell.edu/ns/vitro/0.7#>
     PREFIX owl:   <http://www.w3.org/2002/07/owl#>
     CONSTRUCT { 
          ?role          rdfs:type               owl:Thing .
          ?role          rdfs:type               vivo:Role .
          ?role          rdfs:type               vivo:ResearcherRole .
          ?role          rdfs:type               vivo:PrincipalInvestigatorRole .
          ?role          vitro:mostSpecificType  vivo:PrincipalInvestigatorRole .
     }
     WHERE {  
          <#{grant_uri}>  vivo:relatedRole        ?role .
           ?role          vivo:principalInvestigatorRoleOf  <#{person_uri}>
          { SELECT distinct ?grant (count(?roles) as ?count)
          WHERE { OPTIONAL { <#{person_uri}>    vivo:hasPrincipalInvestigatorRole     ?role }
                  OPTIONAL { <#{person_uri}>    vivo:hasCo-PrincipalInvestigatorRole  ?role }
                  ?role     vivo:roleContributesTo   ?grant .
                  ?grant    vivo:contributingRole    ?roles . 
                  ?role     vivo:roleContributesTo    <#{grant_uri}> .
                }  GROUP BY ?grant
     }   } HAVING (?count > 1)"
  end 

    def self.inference_sparql_construct3(person_uri, grant_uri)
    "PREFIX vivo: <http://vivoweb.org/ontology/core#>
     PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#>
     PREFIX vitro: <http://vitro.mannlib.cornell.edu/ns/vitro/0.7#>
     PREFIX owl:   <http://www.w3.org/2002/07/owl#>
     CONSTRUCT { 
          <#{grant_uri}> vitro:mostSpecificType  vivo:Grant .
          <#{grant_uri}> rdfs:type               vivo:Grant .
          <#{grant_uri}> rdfs:type               owl:Thing .
          <#{grant_uri}> rdfs:type               vivo:Agreement .
          ?role          rdfs:type               owl:Thing .
          ?role          rdfs:type               vivo:Role .
          ?role          rdfs:type               vivo:ResearcherRole .
          ?role          rdfs:type               vivo:CoPrincipalInvestigatorRole .
          ?role          vitro:mostSpecificType  vivo:CoPrincipalInvestigatorRole .
     }
     WHERE {  
          <#{grant_uri}>  vivo:relatedRole                  ?role .
           ?role          vivo:principalInvestigatorRoleOf  <#{person_uri}>
          { SELECT distinct ?grant (count(?roles) as ?count)
          WHERE { OPTIONAL { <#{person_uri}>    vivo:hasPrincipalInvestigatorRole     ?role }
                  OPTIONAL { <#{person_uri}>    vivo:hasCo-PrincipalInvestigatorRole  ?role }
                  ?role     vivo:roleContributesTo   ?grant .
                  ?grant    vivo:contributingRole    ?roles . 
                  ?role     vivo:roleContributesTo    <#{grant_uri}> .
                }  GROUP BY ?grant
     }   } HAVING (?count = 1)"
  end 
 
  def self.inference_sparql_construct4(person_uri, grant_uri)
    # Co-PI on grant with other faculty associated.  (when hiding, don't get rid of grant)
    "PREFIX vivo: <http://vivoweb.org/ontology/core#>
     PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#>
     PREFIX vitro: <http://vitro.mannlib.cornell.edu/ns/vitro/0.7#>
     PREFIX owl:   <http://www.w3.org/2002/07/owl#>
     CONSTRUCT { 
          ?role          rdfs:type                owl:Thing .
          ?role          rdfs:type                vivo:Role .
          ?role          rdfs:type                vivo:ResearcherRole .
          ?role          rdfs:type                vivo:CoPrincipalInvestigatorRole .
          ?role          vitro:mostSpecificType   vivo:CoPrincipalInvestigatorRole .
     }
     WHERE {  
          <#{grant_uri}>  vivo:relatedRole        ?role .
           ?role          vivo:principalInvestigatorRoleOf  <#{person_uri}>
          { SELECT distinct ?grant (count(?roles) as ?count)
          WHERE {            <#{person_uri}>    vivo:hasPrincipalInvestigatorRole     ?role .
                  OPTIONAL { <#{person_uri}>    vivo:hasCo-PrincipalInvestigatorRole  ?role }
                  ?role     vivo:roleContributesTo   ?grant .
                  ?grant    vivo:contributingRole    ?roles . 
                  ?role     vivo:roleContributesTo    <#{grant_uri}> .
                }  GROUP BY ?grant
     }   } HAVING (?count > 1)"
  end 

  def uri(namespace,g)
    "#{namespace}gra#{g.uid}"
  end

  def types(g)
    [core("Grant")]
  end

  def inferred_types(g)
    [core("Agreement"), owl("Thing")]
  end

  def parent(g)
    VivoMapper::Grant.new(:uid => g.parent_uid).stub  if g.parent_uid
  end

  def child_maps(g)
    [investigator(g), institution(g)]
  end

  def investigator(g)
    VivoMapper::InvestigatorRole.new(:uid => g.uid, :person_uid => g.person_uid, :label => g.faculty_name, :role_type => investigator_role(g), :start_date => g.start_date, :end_date => g.end_date)
  end

  def institution(g)
    VivoMapper::Institution.new(:uid => g.institution_uid, :institution_type => 'FundingOrganization', :label => g.sponsor)
  end

  def properties(g)
     {
      rdfs("label")            => g.label,
      core("contributingRole") => investigator(g),
      core("subGrantOf")       => parent(g),
      core("administeredBy")   => VivoMapper::Organization.new(:uid => g.organization_uid).stub,
      core("grantAwardedBy")   => institution(g),
      core("dateTimeInterval") => g.date_interval
    } 
  end
 
  def investigator_role(g)
    g.investigator_role == 'PI' ?  'PrincipalInvestigatorRole' : 'CoPrincipalInvestigatorRole'
  end

  def graph_for(person_uri, model, map_type='Regular')
    graph_model = ModelFactory.create_default_model

    item_query = QueryFactory.create(staging_uris(person_uri));
    item_qexec = QueryExecutionFactory.create(item_query, model);
    item_uris = item_qexec.execSelect();
    while item_uris.has_next do 
      item_uri = item_uris.next.get('?grant')
      sparql_constructs = sparql_constructs(person_uri, item_uri, map_type)
      sparql_constructs.each do |sparql_construct|
        query = QueryFactory.create(sparql_construct);
        qexec = QueryExecutionFactory.create(query, model);
        results = qexec.execConstruct();
        graph_model.add(results)
        qexec.close() ;
      end
    end
    item_qexec.close() ;
    puts "*************************"
    puts graph_model
    puts "*************************"
    graph_model
  end

end
