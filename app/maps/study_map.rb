module StudyMap
  include RdfPrefixes

  extend self

  def uri(namespace,study)
    "#{namespace}#{study.nct_id}"
  end

  def types(study)
    [wde('Q30612'), wde('Q1331083')]
  end

  def inferred_types(study)
    [owl("Thing")]
  end

  def properties(study)
    {
      rdfs("label")       => (study.brief_title  if study.brief_title),
      wdp('P1476')        => (study.official_title  if study.official_title),       # <<<
      #wds('P580')        => (study.start_date  if study.start_date),
      #wds('P582')        => (study.completion_date  if study.completion_date),
      wdp('P1132')        => (study.enrollment         if study.enrollment),       # <<<<
      wdp('P4844')        => (study.all_interventions  if study.all_interventions),
      wdp('P1813')        => (study.acronym            if study.acronym),
      wdp('P3098')        => (study.nct_id),                                       # <<<
      wdp('P2175')        => (study.all_conditions     if study.all_conditions),
      #wdp("P17")         => (study.country_uid  if study.country_uid),
      #ocre("OCRE741000") => (study.phase       if study.phase),
    }
  end

end
