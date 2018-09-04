module AppointmentMap
  include RdfPrefixes

  extend self

  def uri(namespace,appointment)
    "#{namespace}apt#{appointment.uid}"
  end

  def types(appointment)
    [core("#{appointment.position_type}Position")]
  end

  def inferred_types(a)
    [core("Position"), owl("Thing")]
  end

  def properties(a)
    {
      rdfs("label")             => a.title,
      core("hrJobTitle")        => a.title,
      duke("displayOrder")      => a.display_order,
      core("positionForPerson") => VivoMapper::Person.new(:uid => a.person_uid).stub,
      core("positionInOrganization") => VivoMapper::Organization.new(:uid => a.organization_uid).stub,
      core("dateTimeInterval")  => a.date_interval
    }
  end

end
