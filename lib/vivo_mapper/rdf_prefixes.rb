module RdfPrefixes
  extend self

  PREFIX_DEFN = {
    "wikibase" => "http://wikiba.se/ontology#",
    "wdp"     => "https://www.wikidata.org/wiki/Property:",
    "wde"     => "http://www.wikidata.org/entity#",
    "rdf"     => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
    "rdfs"    => "http://www.w3.org/2000/01/rdf-schema#",
    "xsd"     => "http://www.w3.org/2001/XMLSchema#",
    "owl"     => "http://www.w3.org/2002/07/owl#",
    "swrl"    => "http://www.w3.org/2003/11/swrl#",
    "swrlb"   => "http://www.w3.org/2003/11/swrlb#",
    "vitro"   => "http://vitro.mannlib.cornell.edu/ns/vitro/0.7#",
    "auth"    => "http://vitro.mannlib.cornell.edu/ns/vitro/authorization#",
    "bibo"    => "http://purl.org/ontology/bibo/",
    "dcelem"  => "http://purl.org/dc/elements/1.1/",
    "dcterms" => "http://purl.org/dc/terms/",
    "duke"    => "http://vivo.duke.edu/vivo/ontology/duke-extension#",
    "event"   => "http://purl.org/NET/c4dm/event.owl#",
    "foaf"    => "http://xmlns.com/foaf/0.1/",
    "geo"     => "http://aims.fao.org/aos/geopolitical.owl#",
    "pvs"     => "http://vivoweb.org/ontology/provenance-support#",
    "ero"     => "http://purl.obolibrary.org/obo/",
    "scires"  => "http://vivoweb.org/ontology/scientific-research#",
    "skos"    => "http://www.w3.org/2004/02/skos/core#",
    "public"  => "http://vitro.mannlib.cornell.edu/ns/vitro/public#",
    "core"    => "http://vivoweb.org/ontology/core#",
    "ocre"    => "http://purl.org/net/OCRe/OCRe.owl#",
    "OCRe_ext" =>"http://purl.org/net/OCRe/OCRe_ext.owl#",
    "ontologies" => "http://purl.org/net/OCRe/#"
  }


  def method_missing(method_sym,*args, &block)
    if prefix = PREFIX_DEFN[method_sym.to_s]
      "#{prefix}#{args.first}"
    else
      super
    end
  end

  def most_specific_type(mappable)
    types(mappable).first
  end

  def child_maps(mapping)
    []
  end

  def inferred_types(x)
    [owl("Thing")]
  end

end
