module FacilityMap
  include RdfPrefixes

  extend self

  def uri(namespace,instance)
    "#{namespace}#{instance.nct_id}"
  end

  def types(instance)
    [wde("Q13226383")]  # facility
  end

  def inferred_types(instance)
    [foaf("Agent"), owl("Thing")]
  end

  def properties(instance)
    {
      wde("Q30612")   => VivoMapper::Study.new(:uid => instance.nct_id).stub,
      wde('Q1093829') => LookupCity.where('name = ?',instance.city).first.qid,   # City
      wde('Q35657')   => LookupState.where('name = ?',instance.state).first.qid,   # State
      rdfs("label")   => (instance.name  if instance.name),
      wdp("P17")      => LookupCountry.where('name = ?',instance.country).first.qid,   # Country
    }
  end

end
