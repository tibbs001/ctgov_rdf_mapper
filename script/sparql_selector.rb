$LOAD_PATH.unshift(File.dirname(__FILE__) + "/../config")
require 'environment'

SPARQL = <<-EOS
  PREFIX rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
  PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#>
  PREFIX xsd:   <http://www.w3.org/2001/XMLSchema#>
  PREFIX owl:   <http://www.w3.org/2002/07/owl#>
  PREFIX swrl:  <http://www.w3.org/2003/11/swrl#>
  PREFIX swrlb: <http://www.w3.org/2003/11/swrlb#>
  PREFIX vitro: <http://vitro.mannlib.cornell.edu/ns/vitro/0.7#>
  PREFIX bibo: <http://purl.org/ontology/bibo/>
  PREFIX dcelem: <http://purl.org/dc/elements/1.1/>
  PREFIX dcterms: <http://purl.org/dc/terms/>
  PREFIX duke: <http://vivo.duke.edu/vivo/ontology/duke-extension#>
  PREFIX event: <http://purl.org/NET/c4dm/event.owl#>
  PREFIX foaf: <http://xmlns.com/foaf/0.1/>
  PREFIX geo: <http://aims.fao.org/aos/geopolitical.owl#>
  PREFIX pvs: <http://vivoweb.org/ontology/provenance-support#>
  PREFIX ero: <http://purl.obolibrary.org/obo/>
  PREFIX scires: <http://vivoweb.org/ontology/scientific-research#>
  PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
  PREFIX vitro-public: <http://vitro.mannlib.cornell.edu/ns/vitro/public#>
  PREFIX vivo: <http://vivoweb.org/ontology/core#>

  SELECT  ?person_label ?org_label ?org_unit ?pos1 ?pos1_label ?pos1_type_label ?pos2 ?pos2_label ?pos2_type_label
  WHERE
  {
         ?pos1    vivo:positionInOrganization   ?org .
         ?person  vivo:personInPosition         ?pos1 .
         ?person  rdfs:label                    ?person_label .
         ?org     duke:orgUnit                  ?org_unit .

         ?org     rdfs:label                    ?org_label .
         ?pos1    rdfs:label                    ?pos1_label .
         ?pos1    vitro:mostSpecificType        ?pos1_type .
         ?pos1_type rdfs:label                  ?pos1_type_label .

         ?pos2    vivo:positionInOrganization   ?org .
         ?person  vivo:personInPosition         ?pos2 .
         ?pos2    rdfs:label                    ?pos2_label .
         ?pos2    vitro:mostSpecificType        ?pos2_type .
         ?pos2_type rdfs:label                  ?pos2_type_label .

         FILTER ( (?pos1 != ?pos2) && (?pos1_type = ?pos2_type) )
  }
EOS

s = VivoMapper::SparqlSelector.new(SPARQL)
SDB_CONFIG.destination_sdb.with_union_model {|union| STDOUT.puts s.from_model(union).as_csv}
