class OrganizationMerging < ActiveRecord::Base

  def self.for_select
    OrganizationMerging.all.sort_by{|org|[org.vivo_display_name, org.bfr_code]}
  end

  def self.for_list
    OrganizationMerging.all.sort_by{|org|[org.vivo_display_name, org.visible_org.organizational_unit, org.subordinate_description, org.subordinate_bfr_code]}
  end

  def self.visible_orgs
    @orgs = self.find(:all, :condition => 'visible_organizational_unit is not null')
    @orgs.sort! { |a,b| a.vivo_display_name <=> b.subordinate_description }
  end

  def self.organization_types
    types = Array.new
    types.push self.selection_prompt
    types.push "Academic Department"
    types.push "Center"
    types.push "Department"
    types.push "Institute"
    types.push "Program"
    types.push "School"
    return types
  end
 
  def self.selection_prompt
    "Select Org Type"
  end

  def self.default_type
    self.organization_types.second
  end

  def org
    Organization.find(:all, :conditions => "organizational_unit = #{organizational_unit} and start_date <= sysdate and end_date > sysdate").first
  end

  def visible_org
    return org if visible_organizational_unit.nil?
    Organization.find(:all, :conditions => "organizational_unit = #{visible_organizational_unit} and start_date <= sysdate and end_date > sysdate").first
  end

  def id
    organizational_unit
  end

  def display_name
    return org.display_name if org.display_name
    "#{description} - No Display Name"
  end

  def description
    org.description
  end

  def subordinate_bfr_code
    return '' if is_top_level?
    org.bfr_code
  end

  def subordinate_description
    return '' if is_top_level?
    org.description
  end

  def subordinate_organizational_unit
    return '' if is_top_level?
    organizational_unit
  end

  def bfr_code
    org.bfr_code
  end

  def master_bfr_code
    return '' if ! is_top_level?
    visible_org.bfr_code
  end

  def master_organizational_unit
    return '' if ! is_top_level?
    visible_org.organizational_unit
  end

  def master_organization_type
    return '' if ! is_top_level?
    visible_org.organization_type
  end

  def master_display_name
    return '' if ! is_top_level?
    return visible_org.display_name if visible_org.display_name
    "#{description} - No Display Name"
  end

  def vivo_display_name
    return visible_org.display_name if visible_org.display_name
    return "#{visible_org.description} - No Display Name"
  end

  def selection_display_name
    if visible_org.display_name
      "#{visible_org.display_name} (#{bfr_code})  (#{organizational_unit})"
    else
      "#{description} (#{organizational_unit})"
    end
  end

  def is_top_level?
    visible_organizational_unit.nil? or visible_organizational_unit == organizational_unit
  end
end
