module JournalMap
  include RdfPrefixes

  extend self

  def uri(namespace,j)
    "#{namespace}jou#{j.uid}"
  end

  def types(j)
    [bibo(j.most_specific_type)]
  end
 
  def inferred_types(j)
    [core("InformationResource"), bibo("Periodical"), bibo("Journal"), bibo("Collection"), owl("Thing")]
  end

  def properties(j)
    { 
      rdfs("label") => j.label,
      vitro("mostSpecificType") => j.most_specific_type 
    } 
  end

end
