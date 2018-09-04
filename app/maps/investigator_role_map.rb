module InvestigatorRoleMap
  include RdfPrefixes

  extend self

  def uri(namespace,role)
    "#{namespace}investigatorRole#{uid(role)}"
  end

  def types(role)
    [core(role.role_type)]
  end

  def inferred_types(role)
    [core("InvestigatorRole"), core("ResearcherRole"), core("Role"), owl("Thing")]
  end

  def properties(role)
    {
      rdfs("label") => role.label,
      core("roleContributesTo") => VivoMapper::Grant.new(:uid => role.uid).stub,
      core(predicate_link_to_investigator(role)) => VivoMapper::Person.new(:uid => role.person_uid).stub,
      core("dateTimeInterval") => role.date_interval
    }
  end

  def predicate_link_to_investigator(role)
    role.role_type == 'CoPrincipalInvestigatorRole' ?  "co-PrincipalInvestigatorRoleOf" : "principalInvestigatorRoleOf"
  end

  def uid(role)
    "#{role.uid}-#{role.person_uid}"
  end
end
