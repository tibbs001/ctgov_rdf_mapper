class Address < ActiveRecord::Base

  self.table_name = 'v_addresses'
 
  def self.from_file(filename)
    addrs = []
    rows = FasterCSV.read(filename, :headers => true)
    rows.each do |row|
      params = {
       :uid          => row[0],
       :label        => row[1],
       :person_uid   => row[2],
       :street       => row[3],
       :city         => row[4],
       :state        => row[5],
       :zip_code     => row[6],
       :country      => row[7],
       :address_type => row[8],
       :phone        => row[9],
      } 
      addrs << VivoMapper::Address.new(params)
    end
    addrs
  end

  def self.for_duids(duids)
    array = Address.where('label is not null').value_of :unique_id, :label, :person_uid, :street, :city, :state, :zip_code, :country, :address_type, :phone
    all_addrs = []
    array = array.select{ |a| duids.include? a[2]}
    array.map {|a| 
      all_addrs << VivoMapper::Address.new(
       :uid          => a[0],
       :label        => a[1],
       :person_uid   => a[2],
       :street       => a[3],
       :city         => a[4],
       :state        => a[5],
       :zip_code     => a[6],
       :country      => a[7],
       :address_type => a[8],
       :phone        => a[9])
    } 
      all_addrs
  end

  def self.destined_for_vivo(duids)
    Hide.remove_hidden_from(self.for_duids(duids),'Address')
  end

  def self.for_vivo
    self.destined_for_vivo(Person.duids_for_vivo)
  end

end
