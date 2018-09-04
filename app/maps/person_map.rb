module PersonMap
  include RdfPrefixes

  extend self

  def uri(namespace,person)
    "#{namespace}per#{person.uid}"
  end

  def types(person)
    [core("#{person.type}")]
  end

  def inferred_types(person)
    [foaf("Person"), foaf("Agent"), owl("Thing")]
  end

  def properties(person)
    {
      rdfs("label")          => (person.label       if person.label),
      duke("duid")           => (person.uid         if person.uid),
      duke("scopedNetid")    => (person.netid       if person.netid),
      foaf("firstName")      => (person.first_name  if person.first_name),
      core("middleName")     => (person.mid_name    if person.mid_name),
      foaf("lastName")       => (person.last_name   if person.last_name),
      core("preferredTitle") => (person.title       if person.title),
      bibo("prefixName")     => (person.name_prefix if person.name_prefix),
      bibo("suffixName")     => (person.name_suffix if person.name_suffix),
      core("phoneNumber")    => (person.phone       if person.phone),
      core("overview")       => (person.overview    if person.overview),
    }
  end

end
