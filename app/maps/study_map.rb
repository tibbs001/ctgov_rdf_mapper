module StudyMap
  include RdfPrefixes

  extend self

  def uri(namespace,study)
    "#{namespace}#{study.nct_id}"
  end

  def types(study)
    [ontologies("OCRE9000031")] #, wde('Q30612'), wde('Q1331083')]
  end

  def inferred_types(study)
    [owl("Thing")]
  end

  def properties(study)
    {
      rdfs("label")       => (study.brief_title  if study.brief_title),
      #ocre("OCRE741000") => (study.phase       if study.phase),
      ocre("OCRE189000")  => (study.description  if study.description),
      ocre("OCRE900223")  => (study.description  if study.description),
      ocre("OCRE900237")  => (study.enrollment   if study.enrollment),
      wdp("P3098")        => (study.nct_id),
      wdp("P17")          => (study.country_uid  if study.country_uid),
      #wds("P571")         => (study.start_date  if study.start_date),  #inception
    }
  end

end
