module ProfessorshipMap
  include RdfPrefixes

  extend self

  def uri(namespace,professorship)
    "#{namespace}professorship#{professorship.uid}"
  end

  def types(professorship)
    [duke("Professorship")]
  end

  def inferred_types(professorship)
    [owl("Thing"), core("Position")]
  end

  def properties(professorship)
    {
      rdfs("label")             => professorship.title,
      core("hrJobTitle")        => professorship.title,
      duke("displayOrder")      => professorship.display_order,
      core("positionForPerson") => VivoMapper::Person.new(:uid => professorship.person_uid).stub,
      core("positionInOrganization") => VivoMapper::Organization.new(:uid => professorship.organization_uid).stub,
      core("dateTimeInterval")  => professorship.date_interval
    }
  end

end
