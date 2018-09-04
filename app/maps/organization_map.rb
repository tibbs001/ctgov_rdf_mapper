module OrganizationMap
  include RdfPrefixes

  extend self

  def uri(namespace,organization)
    "#{namespace}org#{organization.uid}"
  end

  def types(organization)
    [core("#{organization.type}")]
  end

  def inferred_types(organization)
    [foaf("Organization"), foaf("Agent"), owl("Thing")]
  end

  def properties(a)
    map = {
      duke("orgUnit") => a.uid,
      rdfs("label")   => a.label
    }
    map.merge!(core("subOrganizationWithin") => VivoMapper::Organization.new(:uid => a.parent_organization_uid).stub) if a.parent_organization_uid && a.parent_organization_uid != ""
    map
  end

end
