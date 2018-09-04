module CountryMap
  include RdfPrefixes

  extend self

  def uri(namespace, country)
    "https://www.wikidata.org/wiki/#{country.nct_id}"
  end

  def inferred_types(sponsor)
    [foaf("Agent"), owl("Thing")]
  end

  def properties(sponsor)
    {
      ontologies("OCRE9000031")   => VivoMapper::Study.new(:uid => sponsor.nct_id).stub,
      rdfs("label")    => (sponsor.name  if sponsor.name),
    }
  end

end
