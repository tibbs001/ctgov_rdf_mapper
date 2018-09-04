module SponsorMap
  include RdfPrefixes

  extend self

  def uri(namespace,sponsor)
    "#{namespace}#{sponsor.nct_id}"
  end

  def types(sponsor)
    [OCRe_ext("OCRE571000")]
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
