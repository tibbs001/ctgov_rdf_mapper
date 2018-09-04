require 'csv'

class Education
 
  def self.from_file(filename)
    educations = []
    rows = CSV.read(filename, :headers => true)
    rows.each do |row|
      params = {
       :uid                  => row[0],
       :label                => row[1],
       :person_uid           => row[2],
       :institution_uid      => row[3],
       :degree_uid           => row[4],
       :major_field_of_study => row[5],
       :end_year             => (DateTime.parse(row[6]).year if (row[6] and row[6] != "")),
      }  
      educations << VivoMapper::Education.new(params) if row[0] && row[1] && row[2] && row [3] && row[4] && row[6]
    end
    educations
  end

  def self.destined_for_vivo(duids=[])
    csv_records = from_file(File.join(MAPPER_ROOT,'incoming_files','Education.csv'))
    to_vivo =  duids.empty? ? csv_records : csv_records.select{|cr| duids.include?(cr.person_uid) } # limit duids if passed, otherwise load everyone
    Hide.remove_hidden_from(to_vivo,'Education')
  end

end
