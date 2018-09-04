class VivoProxyOrganization

  attr_reader :organizational_unit, :organization_type_uri, :label, :parent_unit

  def initialize(organizational_unit,organization_type_uri, label, parent_unit)
    @organizational_unit, @organization_type_uri,  @label,  @parent_unit = organizational_unit,organization_type_uri, label, parent_unit
  end

  def self.for(org)
    return new(org.organizational_unit, 'School', org.label, nil) if org == Organization.top_organization
    proxy_org = get_vivo_proxy(org)
    if proxy_org
      if parent_proxy_org = get_vivo_proxy(Organization.find_by_organizational_unit(proxy_org.parent_unit))
        new(proxy_org.organizational_unit, proxy_org.organization_type_uri, proxy_org.label, parent_proxy_org.organizational_unit)
      else
        new(proxy_org.organizational_unit, proxy_org.organization_type_uri, proxy_org.label, nil)
      end
    end
  end

  def school_organizational_unit
    (is_school? || is_top_organization?)  ?  organizational_unit : VivoProxyOrganization.for(parent).school_organizational_unit
  end

  def is_school?
    organization_type_uri == 'School'
  end

  def is_top_organization?
    organizational_unit == Organization.top_organizational_unit
  end

  def parent
    Organization.find_by_organizational_unit(parent_unit.to_i)
  end

  def hash
    [organizational_unit,organization_type_uri, label, parent_unit].hash
  end

  def eql?(other)
    self == other
  end

  def ==(other)
    return false unless other.is_a? VivoProxyOrganization
    return organizational_unit == other.organizational_unit && organization_type_uri == other.organization_type_uri && label == other.label && parent_unit == other.parent_unit
  end

  protected

  def self.get_vivo_proxy(organization)
    return nil unless organization
    merged = OrganizationMerging.find_by_organizational_unit(organization.organizational_unit)
    if merged
      return Organization.find_by_organizational_unit(merged.visible_organizational_unit)
    elsif organization.can_appoint == 'Y'
      return organization
    else
      proxy=get_vivo_proxy(organization.parent_organization)
      proxy ? proxy : Organization.top_organization
    end
  end

end
