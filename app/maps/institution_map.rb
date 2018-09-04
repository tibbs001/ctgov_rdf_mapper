module InstitutionMap
  include RdfPrefixes

  extend self

  def uri(namespace,i)
    "#{namespace}ins#{i.uid}"
  end

  def types(i)
    [core("#{i.institution_type}")]
  end
 
  def inferred_types(i)
    [foaf("Organization"), foaf("Agent"), owl("Thing")]
  end

  def properties(i)
    { rdfs("label") => i.label } 
  end

end
