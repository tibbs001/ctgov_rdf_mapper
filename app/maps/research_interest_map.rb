module ResearchInterestMap
  include RdfPrefixes

  extend self

  def uri(namespace,ri)
    "#{namespace}concept#{ri.uid}"
  end

  def types(ri)
    [core("Concept")]
  end
 
  def inferred_types(ri)
    [owl("Thing")]
  end

  def properties(ri)
    map = {
      rdfs("label")           => ri.concept,
      core("researchAreaOf")  => VivoMapper::Person.new(:uid => ri.person_uid).stub,
    }
    map
  end

end
