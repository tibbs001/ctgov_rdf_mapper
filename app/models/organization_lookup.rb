class OrganizationLookup < ActiveRecord::Base

  def self.proxy_org_unit_for(org_unit)
    lookup=OrganizationLookup.find_by_organizational_unit(org_unit)
    return Organization.top_organizational_unit if ! lookup
    ActiveSupport::JSON.decode(lookup.organization)["uid"].to_s
  end

  def self.proxy_org_unit_for_bfr_code(bfr_code)
    lookup=OrganizationLookup.find_by_bfr_code(bfr_code)
    return Organization.top_organizational_unit if ! lookup
    ActiveSupport::JSON.decode(lookup.organization)["uid"].to_s
  end
  
  def self.refresh
      OrganizationLookup.delete_all_rows 
      Organization.all_orgs.each do |org|
        proxy= VivoProxyOrganization.for(org)
        if proxy
          vivo_org = VivoMapper::Organization.new({
             :uid        => proxy.organizational_unit,
             :type       => proxy.organization_type_uri,
             :label      => proxy.label,
             :parent_organization_uid => proxy.parent_unit
          }) 
          add_org_lookup_for(org.organizational_unit, org.bfr_code, proxy.school_organizational_unit, vivo_org) 
        else
          puts "NO PROXY FOR #{org.organizational_unit}"
        end
    end
  end

  def self.delete_all_rows
    OrganizationLookup.connection.execute('delete from organization_lookups where id is not null')
  end

  def self.add_org_lookup_for(org_unit, bfr_code, school, vivo_org)
    OrganizationLookup.create(
              :organizational_unit => org_unit, 
              :bfr_code => bfr_code, 
              :vivo_organizational_unit => vivo_org.uid.to_s, 
              :school_organizational_unit => school, 
              :organization => vivo_org.to_json)
  end
end
