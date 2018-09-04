require 'date'
class Professorship < ActiveRecord::Base

  self.table_name = 'V_CURRENT_PROFESSORSHIPS'

  def self.for_duids(duids)
    array = Professorship.where('duid is not null').value_of :unique_id, :title, :duid, :organizational_unit, :start_date, :end_date
    all = []
    array = array.select{ |a| duids.include? a[2]}
    array.map {|a| 
      all << VivoMapper::Professorship.new(
         :uid              => a[0],
         :label            => a[1],
         :title            => a[1],
         :person_uid       => a[2],
         :organization_uid => OrganizationLookup.proxy_org_unit_for(a[3]),
         :start_date       => (DateTime.parse(a[4]) if ! a[4].blank? ),
         :end_date         => (DateTime.parse(a[5]) if ( ! a[5].blank? and a[5] != "12/31/9999")),
         :display_order    => '0' )
    } 
      all
  end

  def self.destined_for_vivo(duids)
    Hide.remove_hidden_from(self.for_duids(duids),'Professorship')
  end

  def self.for_vivo
    self.destined_for_vivo(Person.duids_for_vivo)
  end

end
