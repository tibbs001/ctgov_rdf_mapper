module DegreeMap
  include RdfPrefixes

  extend self

  def uri(namespace,degree)
    "#{namespace}degree#{degree.uid}"
  end

  def types(degree)
    [core("AcademicDegree")]
  end

  def inferred_types(d)
    [owl("Thing")]
  end

  def properties(d)
    map = {
      rdfs("label")        => d.label,
      core("abbreviation") => d.degree_abbreviation
    }
    map
  end

end
