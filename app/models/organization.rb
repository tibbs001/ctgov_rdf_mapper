class Organization < ActiveRecord::Base

  self.table_name = 'V_CURRENT_ORGANIZATIONS'

  def self.for_vivo(flag='refresh_lookup')
    orgs = []
    OrganizationLookup.delete_all_rows if flag == 'refresh_lookup'
    all_orgs.each do |org|
      proxy= VivoProxyOrganization.for(org)
      if proxy
        new_org = VivoMapper::Organization.new({
         :uid        => proxy.organizational_unit,
         :type       => proxy.organization_type_uri,
         :label      => proxy.label,
         :parent_organization_uid => proxy.parent_unit
        }) 
        orgs << new_org
        add_org_lookup_for(org.organizational_unit, org.bfr_code, proxy.school_organizational_unit, new_org) if flag == 'refresh_lookup'
      else
        puts "NO PROXY FOR #{org.organizational_unit}"
      end
    end
    return orgs.uniq
  end

  def self.add_org_lookup_for(org_unit, bfr_code, school, proxy)
    lkup=OrganizationLookup.new(:organization => proxy.to_json)
    lkup.organizational_unit=org_unit
    lkup.bfr_code=bfr_code
    lkup.vivo_organizational_unit = proxy.uid.to_s
    lkup.school_organizational_unit = school
    lkup.save
  end

  def self.all_orgs
    @orgs ||= Organization.all.to_a

  end

  def self.find_by_organizational_unit(o)
     all_orgs.select{|org| org.organizational_unit == o }[0]
  end

  def self.top_organizational_unit
    50000021
  end

  def self.top_organization
    find_by_organizational_unit(self.top_organizational_unit)
  end

  def uid
    organizational_unit
  end
  
  def organization_type_uri
    organization_type.gsub(" ","")
  end

  def parent_organization
    parent_unit ? Organization.find_by_organizational_unit(parent_unit) : Organization.top_organization
  end

  def organization_type
    map = OrganizationMerging.find_by_organizational_unit(organizational_unit)
    if map and map.organization_type
      map.organization_type
    else
      "Academic Department"
    end
  end

  def label
    display_name ? display_name : "#{description} (DISPLAY NAME MISSING)"
  end

end
