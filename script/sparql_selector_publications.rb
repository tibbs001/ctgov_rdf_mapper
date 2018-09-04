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

SELECT ?uid ?title ?pubDate ?volume ?issue ?pageStart ?pageEnd ?authorList ?author ?authorName ?authorRank ?journal_uri ?journalName ?mostSpecificType
WHERE
{
      ?uid               rdf:type                             bibo:Document .
      ?uid               vitro:mostSpecificType               ?mostSpecificType .
      ?uid               bibo:issue                           ?issue .
      ?uid               vivo:dateTimeValue                   ?pub_date_uri .
      ?pub_date_uri      vivo:dateTime                        ?pubDate .
      ?uid               duke:authorList                      ?authorList .
      ?uid               dcterms:title                        ?title .
      ?uid               bibo:pageStart                       ?pageStart .
      ?uid               bibo:pageEnd                         ?pageEnd .
      ?uid               bibo:issue                           ?issue .
      ?uid               bibo:volume                          ?volume .
      ?uid               vivo:hasPublicationVenue             ?journal_uri .
      ?journal_uri       rdfs:label                           ?journalName .
      ?uid               vivo:informationResourceInAuthorship ?authorship .
      ?authorship        vivo:authorRank                      ?authorRank .
      ?authorship        vivo:linkedAuthor                    ?author  .
      ?author            rdfs:label                           ?authorName 
}

EOS

s = VivoMapper::SparqlSelector.new(SPARQL)
SDB_CONFIG.destination_sdb.with_union_model {|union| STDOUT.puts s.from_model(union).as_csv}
