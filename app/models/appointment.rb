require 'date'

class Appointment

  def self.from_file(filename)
    appts = []
    rows = FasterCSV.read(filename, :headers => true)
    rows.each do |row|
        params = {
         :uid                => row[0],
         :label              => row[1],
         :person_uid         => row[2],
         :title              => row[3],
         :organization_uid   => OrganizationLookup.proxy_org_unit_for(row[4]),
         :start_date         => (DateTime.parse(row[5]) if ( ! row[5].blank? )),
         :end_date           => (DateTime.parse(row[6]) if ( ! row[6].blank? && row[6] != '12/31/9999')),
         :position_type      => ("#{row[7]}" if row[7]),
         :display_order      => row[8]
        } 
        appts << VivoMapper::Appointment.new(params)
    end
    appts
  end

end
