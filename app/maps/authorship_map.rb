module AuthorshipMap
  include RdfPrefixes

  extend self

  def uri(namespace,a)
    "#{namespace}author#{a.uid}"
  end

  def types(a)
    [core("Authorship")]
  end

  def inferred_types(a)
    [core("Relationship"), owl("Thing")]
 end

  def properties(a)
    {
      rdfs("label")        => a.label,
      core("authorRank")   => (a.author_rank if a.author_rank),
      core("linkedAuthor") => (VivoMapper::Person.new(:uid => a.author_uid).stub if a.author_uid),
    } 
  end

end
